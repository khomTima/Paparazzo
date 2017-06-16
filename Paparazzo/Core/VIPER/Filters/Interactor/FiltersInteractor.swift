import Foundation
import ImageSource

protocol FiltersInteractor: class {
    var image: ImageSource { get }
    var modifiedImage: ImageSource? { get }
    var filters: [Filter] { get }
    
    func apply(filter: Filter, completion: @escaping ((_ modifiedImage: ImageSource) -> Void))
}
