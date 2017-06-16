import Foundation
import ImageSource
import CoreGraphics
import ImageIO
import ImageSource
import MobileCoreServices

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
            
            let options = ImageRequestOptions(size: .fullResolution, deliveryMode: .best)
            
            self.interactor.image.requestImage(options: options) { (result: ImageRequestResult<UIImage>) in
                if let image = result.image {
                    DispatchQueue.global(priority: .high).async {
                        filter.apply(image, completion: { filteredImage in
                            
                            let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("\(UUID().uuidString).jpg")
                            let url = URL(fileURLWithPath: path)
                            let destination = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeJPEG, 1, nil)
                            
                            if let destination = destination {
                                guard let cgImage = filteredImage.cgImage else { return }
                                
                                CGImageDestinationAddImage(destination, cgImage, nil)
                                
                                if CGImageDestinationFinalize(destination) {
                                    let imageSource = LocalImageSource(path: path, previewImage: cgImage)
                                    DispatchQueue.main.async {
                                        self.view?.setImage(imageSource, filters: self.interactor.filters)
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
        
        view?.onConfirmButtonTap = { [weak self] previewImage in
            if let previewImage = previewImage {
                self?.onConfirm?(previewImage)
            } else {
                self?.onDiscard?()
            }
        }
        
        view?.setImage(interactor.image, filters: interactor.filters)
    }
}
