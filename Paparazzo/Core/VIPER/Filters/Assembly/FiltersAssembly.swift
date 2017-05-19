import ImageSource
import UIKit

protocol FiltersAssembly: class {
    func module(
        image: ImageSource,
        filters: [Filter]?,
        configuration: (FiltersModule) -> ())
        -> UIViewController
}

protocol FiltersAssemblyFactory: class {
    func filtersAssembly() -> FiltersAssembly
}
