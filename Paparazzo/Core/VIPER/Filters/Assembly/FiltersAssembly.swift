import ImageSource
import UIKit

protocol FiltersAssembly: class {
    func module(
        image: ImageSource,
        configuration: (FiltersModule) -> ())
        -> UIViewController
}

protocol FiltersAssemblyFactory: class {
    func filtersAssembly() -> FiltersAssembly
}
