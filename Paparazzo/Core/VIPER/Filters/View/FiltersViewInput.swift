import Foundation
import ImageSource

protocol FiltersViewInput: class {
    
    func setTitle(_: String)
    
    func setImage(_: ImageSource, filters: [Filter])
    
    var onFilterTap: ((_ filter: Filter) -> Void)? { get set }
    
    var onLongTap: ((_ recogniserState: UIGestureRecognizerState) -> Void)? { get set }
    
    var onDiscardButtonTap: (() -> ())? { get set }
    var onConfirmButtonTap: ((_ previewImage: ImageSource?) -> ())? { get set }
}
