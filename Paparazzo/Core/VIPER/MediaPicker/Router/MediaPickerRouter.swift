import ImageSource

protocol MediaPickerRouter: class {
    
    func showPhotoLibrary(
        selectedItems: [PhotoLibraryItem],
        maxSelectedItemsCount: Int?,
        configuration: (PhotoLibraryModule) -> ()
    )
    
    func showCroppingModule(
        forImage: ImageSource,
        canvasSize: CGSize,
        configuration: (ImageCroppingModule) -> ()
    )
    
    func showFiltersModule(
        forImage: ImageSource,
        filters: [Filter]?,
        configuration: (FiltersModule) -> ()
    )
    
    func focusOnCurrentModule()
    func dismissCurrentModule()
}
