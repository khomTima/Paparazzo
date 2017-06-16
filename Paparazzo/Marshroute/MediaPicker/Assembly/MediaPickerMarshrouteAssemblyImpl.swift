import Marshroute
import UIKit

public final class MediaPickerMarshrouteAssemblyImpl: MediaPickerMarshrouteAssembly {
    
    typealias AssemblyFactory = CameraAssemblyFactory
        & ImageCroppingAssemblyFactory
        & PhotoLibraryMarshrouteAssemblyFactory
        & FiltersAssemblyFactory
    
    private let assemblyFactory: AssemblyFactory
    private let theme: PaparazzoUITheme
    
    init(assemblyFactory: AssemblyFactory, theme: PaparazzoUITheme) {
        self.assemblyFactory = assemblyFactory
        self.theme = theme
    }
    
    // MARK: - MediaPickerAssembly
    
    public func module(
        items: [MediaPickerItem],
        filters: [Filter]? = nil,
        selectedItem: MediaPickerItem?,
        maxItemsCount: Int?,
        cropEnabled: Bool,
        cropCanvasSize: CGSize,
        routerSeed: RouterSeed,
        configuration: (MediaPickerModule) -> ())
        -> UIViewController
    {
        let interactor = MediaPickerInteractorImpl(
            items: items,
            filters: filters,
            selectedItem: selectedItem,
            maxItemsCount: maxItemsCount,
            cropCanvasSize: cropCanvasSize,
            deviceOrientationService: DeviceOrientationServiceImpl(),
            latestLibraryPhotoProvider: PhotoLibraryLatestPhotoProviderImpl()
        )

        let router = MediaPickerMarshrouteRouter(
            assemblyFactory: assemblyFactory,
            routerSeed: routerSeed
        )
        
        let cameraAssembly = assemblyFactory.cameraAssembly()
        let (cameraView, cameraModuleInput) = cameraAssembly.module()
        
        let presenter = MediaPickerPresenter(
            interactor: interactor,
            router: router,
            cameraModuleInput: cameraModuleInput
        )
        
        let viewController = MediaPickerViewController()
        viewController.addDisposable(presenter)
        viewController.setCameraView(cameraView)
        viewController.setTheme(theme)
        viewController.setShowsCropButton(cropEnabled)
        
        presenter.view = viewController
        
        configuration(presenter)
        
        return viewController
    }
}
