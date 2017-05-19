import Marshroute
import Paparazzo

protocol ExampleRouter: class, RouterFocusable, RouterDismissable {

    func showMediaPicker(
        items: [MediaPickerItem],
        selectedItem: MediaPickerItem?,
        filters: [Filter]?,
        maxItemsCount: Int?,
        cropCanvasSize: CGSize,
        configuration: (MediaPickerModule) -> ()
    )
    
    func showPhotoLibrary(
        selectedItems: [PhotoLibraryItem],
        maxSelectedItemsCount: Int?,
        configuration: (PhotoLibraryModule) -> ()
    )
}
