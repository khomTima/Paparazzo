import ImageSource
import UIKit

final class FiltersView: UIView {
    
    // MARK: - Subviews
    
    private var longTap: UILongPressGestureRecognizer? = nil
    private let previewView = UIImageView()
    private let controlsView = FiltersControlsView()
    private let titleLabel = UILabel()
    private var image: ImageSource? = nil
    private var original: ImageSource? = nil
    private var nonOriginalImage: ImageSource? = nil
    private var filters = [Filter]()
    
    // MARK: - Constants
    
    private let controlsMinHeight: CGFloat = {
        let iPhone5ScreenSize = CGSize(width: 320, height: 568)
        return iPhone5ScreenSize.height - iPhone5ScreenSize.width / 0.75
    }()
    
    var onFilterTap: ((_ filter: Filter) -> Void)? {
        didSet {
            controlsView.onFilterTap = onFilterTap
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.longTap = UILongPressGestureRecognizer(target: self, action: #selector(showOriginal(_:)))
        
        backgroundColor = .white
        clipsToBounds = true
        
        controlsView.onConfirmButtonTap = { [weak self] in
            self?.onConfirmButtonTap?(self?.image)
        }
        
        previewView.contentMode = .scaleAspectFit
        
        previewView.isUserInteractionEnabled = true
    
        longTap?.minimumPressDuration = 0.2
        if let longTap = longTap {
            previewView.addGestureRecognizer(longTap)
        }
        
        titleLabel.textColor = .white
        addSubview(previewView)
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
            height: controlsMinHeight + 40
        )
        
        previewView.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            bottom: controlsView.top
        )
    }
    
    // MARK: - FiltersView
    
    var onDiscardButtonTap: (() -> ())? {
        get { return controlsView.onDiscardButtonTap }
        set { controlsView.onDiscardButtonTap = newValue }
    }
    
    var onConfirmButtonTap: ((_ previewImage: ImageSource?) -> ())?
    
    func setImage(_ image: ImageSource, filters: [Filter]) {
        self.filters = filters
        if original == nil {
            original = image
        }
        self.image = image
        
        let options = ImageRequestOptions(size: .fullResolution, deliveryMode: .best)
        
        controlsView.filters = filters
        
        image.requestImage(options: options) { [weak self] (result: ImageRequestResult<UIImage>) in
            if let image = result.image {
                self?.previewView.image = image
            }
        }
    }

    func setTheme(_ theme: FiltersUITheme) {
        controlsView.setTheme(theme)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func showOriginal(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .ended,
             .cancelled,
             .failed:
            if let nonOriginalImage = nonOriginalImage {
                setImage(nonOriginalImage, filters: filters)
                self.nonOriginalImage = nil
            }
        case .began:
            nonOriginalImage = image
            setImage(original!, filters: filters)
        default:
            break
        }
    }
}
