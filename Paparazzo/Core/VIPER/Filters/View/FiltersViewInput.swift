import Foundation
import ImageSource

protocol FiltersViewInput: class {
    
    func setTitle(_: String)
    
    func setImage(_: ImageSource, previewImage: ImageSource?, completion: @escaping () -> ())
    
    var onDiscardButtonTap: (() -> ())? { get set }
    var onConfirmButtonTap: ((_ previewImage: CGImage?) -> ())? { get set }
}
