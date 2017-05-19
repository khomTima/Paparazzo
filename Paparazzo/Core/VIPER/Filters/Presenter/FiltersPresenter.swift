import Foundation
import ImageSource

final class FiltersPresenter: FiltersModule {

    // MARK: - Dependencies
    
    private var interactor: FiltersInteractor
    
    weak var view: FiltersViewInput? {
        didSet {
            setUpView()
        }
    }

    // MARK: - Init

    init(interactor: FiltersInteractor) {
        self.interactor = interactor
    }
    
    // MARK: - FiltersModule
    
    var onDiscard: (() -> ())?
    var onConfirm: ((ImageSource) -> ())?
    
    // MARK: - Private
    
    private func setUpView() {
        
        view?.setTitle("Фильтры")
        
        view?.onDiscardButtonTap = { [weak self] in
            self?.onDiscard?()
        }
        
        view?.onConfirmButtonTap = { [weak self] previewImage in
            if let previewImage = previewImage {
                
            } else {
                self?.onDiscard?()
            }
        }
    }
}
