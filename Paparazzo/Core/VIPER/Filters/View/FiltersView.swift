import ImageSource
import UIKit

final class FiltersView: UIView {
    
    // MARK: - Subviews
    
    /// Вьюха, которая показывается до того, как будет доступна полная картинка для редактирования (чтобы избежать моргания)
    private let splashView = UIImageView()
    
    private let previewView = UIImageView()
    private let controlsView = FiltersControlsView()
    private let titleLabel = UILabel()
    
    // MARK: - Constants
    
    private let controlsMinHeight: CGFloat = {
        let iPhone5ScreenSize = CGSize(width: 320, height: 568)
        return iPhone5ScreenSize.height - iPhone5ScreenSize.width / 0.75
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = true
        
        controlsView.onConfirmButtonTap = { [weak self] in
            self?.onConfirmButtonTap?(self?.previewView.image?.cgImage)
        }
        
        splashView.contentMode = .scaleAspectFill
        
        addSubview(previewView)
        addSubview(splashView)
        addSubview(controlsView)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.resizeToFitWidth(bounds.size.width)
        titleLabel.centerX = bounds.centerX
        titleLabel.top = 13
        
        controlsView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: max(controlsMinHeight, bounds.size.height - bounds.size.width / 0.75)   // оставляем вверху место под фотку 3:4
        )
        
        previewView.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            bottom: controlsView.top
        )
        
        layoutSplashView()
    }
    
    private func layoutSplashView() {
        
        let height: CGFloat
        
        splashView.size = CGSize(width: bounds.size.width, height: bounds.size.height)
        splashView.center = previewView.center
    }
    
    // MARK: - FiltersView
    
    var onDiscardButtonTap: (() -> ())? {
        get { return controlsView.onDiscardButtonTap }
        set { controlsView.onDiscardButtonTap = newValue }
    }
    
    var onConfirmButtonTap: ((_ previewImage: CGImage?) -> ())?
    
    func setImage(_ image: ImageSource, previewImage: ImageSource?, completion: (() -> ())?) {
        
        if let previewImage = previewImage {
            
            let screenSize = UIScreen.main.bounds.size
            let previewOptions = ImageRequestOptions(size: .fitSize(screenSize), deliveryMode: .progressive)
            
            splashView.isHidden = false
            
            previewImage.requestImage(options: previewOptions) { [weak self] (result: ImageRequestResult<UIImage>) in
                if let image = result.image, self?.splashView.isHidden == false {
                    self?.splashView.image = image
                }
            }
        }
        
        let options = ImageRequestOptions(size: .fullResolution, deliveryMode: .best)
        
        image.requestImage(options: options) { [weak self] (result: ImageRequestResult<UIImage>) in
            if let image = result.image {
                self?.previewView.image = image
                self?.splashView.isHidden = true
                self?.splashView.image = nil
            }
            completion?()
        }
    }

    func setTheme(_ theme: FiltersUITheme) {
        controlsView.setTheme(theme)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
