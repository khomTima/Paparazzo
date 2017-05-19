import Foundation
import ImageSource

protocol FiltersInteractor: class {
    var image: ImageSource { get }
    var filters: [Filter] { get }
}
