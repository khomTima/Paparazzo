import ImageSource
import UIKit

public final class FiltersAssemblyImpl: FiltersAssembly {
    
    private let theme: FiltersUITheme
    
    init(theme: FiltersUITheme) {
        self.theme = theme
    }
    
    public func module(
        image: ImageSource,
        filters: [Filter]?,
        configuration: (FiltersModule) -> ()
    ) -> UIViewController {

        let interactor = FiltersInteractorImpl(
            image: image,
            filters: filters ?? []
        )

        let presenter = FiltersPresenter(
            interactor: interactor
        )

        let viewController = FiltersViewController()
        viewController.addDisposable(presenter)
        viewController.setTheme(theme)

        presenter.view = viewController
        
        configuration(presenter)

        return viewController
    }
}
