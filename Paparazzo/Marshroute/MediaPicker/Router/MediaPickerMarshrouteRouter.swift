import ImageSource
import Marshroute

final class MediaPickerMarshrouteRouter: BaseRouter, MediaPickerRouter {
    
    typealias AssemblyFactory = ImageCroppingAssemblyFactory
        & PhotoLibraryMarshrouteAssemblyFactory
        & FiltersAssemblyFactory

    private let assemblyFactory: AssemblyFactory

    init(assemblyFactory: AssemblyFactory, routerSeed: RouterSeed) {
        self.assemblyFactory = assemblyFactory
        super.init(routerSeed: routerSeed)
    }

    // MARK: - PhotoPickerRouter

    func showPhotoLibrary(
        selectedItems: [PhotoLibraryItem],
        maxSelectedItemsCount: Int?,
        configuration: (PhotoLibraryModule) -> ())
    {
        presentModalNavigationControllerWithRootViewControllerDerivedFrom { routerSeed in
            
            let assembly = assemblyFactory.photoLibraryAssembly()
            
            return assembly.module(
                selectedItems: selectedItems,
                maxSelectedItemsCount: maxSelectedItemsCount,
                routerSeed: routerSeed,
                configuration: configuration
            )
        }
    }
    
    func showCroppingModule(
        forImage image: ImageSource,
        canvasSize: CGSize,
        configuration: (ImageCroppingModule) -> ())
    {
        pushViewControllerDerivedFrom({ _ in
            
            let assembly = assemblyFactory.imageCroppingAssembly()
            
            return assembly.module(
                image: image,
                canvasSize: canvasSize,
                configuration: configuration
            )
            
        }, animator: NonAnimatedPushAnimator())
    }
    
    func showFiltersModule(
        forImage image: ImageSource,
        filters: [Filter]?,
        configuration: (FiltersModule) -> ())
    {
        pushViewControllerDerivedFrom({ _ in
            
            let assembly = assemblyFactory.filtersAssembly()
            
            return assembly.module(
                image: image,
                filters: filters,
                configuration: configuration
            )
            
        }, animator: NonAnimatedPushAnimator())
    }
}
