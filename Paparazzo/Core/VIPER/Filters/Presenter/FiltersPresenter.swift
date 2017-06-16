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
        
        view?.onFilterTap = { [weak self] filter in
            guard let `self` = self else {
                return
            }
            
            self.interactor.apply(filter: filter) { resultImage in
                self.view?.setImage(resultImage, filters: self.interactor.filters)
            }
        }
        
        view?.onConfirmButtonTap = { [weak self] previewImage in
            if let previewImage = previewImage {
                self?.onConfirm?(previewImage)
            } else {
                self?.onDiscard?()
            }
        }
        
        view?.onLongTap = { [weak self] recognizerState in
            guard let `self` = self else {
                return
            }
            
            switch recognizerState {
            case .ended,
                 .cancelled,
                 .failed:
                if let nonOriginalImage = self.interactor.modifiedImage {
                    self.view?.setImage(nonOriginalImage, filters: self.interactor.filters)
                }
            case .began:
                self.view?.setImage(self.interactor.image, filters: self.interactor.filters)
            default:
                break
            }
        }
        
        view?.setImage(interactor.image, filters: interactor.filters)
    }
}
