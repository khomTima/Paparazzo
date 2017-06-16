import ImageSource
import UIKit

final class FiltersView: UIView {
    
    typealias OnLongTap = ((_ recogniserState: UIGestureRecognizerState) -> Void)?
    
    // MARK: - Subviews
    private var longTap: UILongPressGestureRecognizer? = nil
    private let previewView = UIImageView()
    private let controlsView = FiltersControlsView()
    private let titleLabel = UILabel()
    private var image: ImageSource? = nil
    private var onLongTap: OnLongTap
    
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
        
        self.longTap = UILongPressGestureRecognizer(target: self, action: #selector(onLongTap(_:)))
        
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
        self.image = image
        
        let options = ImageRequestOptions(size: .fullResolution, deliveryMode: .best)
        
        controlsView.filters = filters
        
        image.requestImage(options: options) { [weak self] (result: ImageRequestResult<UIImage>) in
            if let image = result.image {
                self?.previewView.image = image
            }
        }
    }
    
    func setOnLongTap(_ onLongTap: OnLongTap) {
        self.onLongTap = onLongTap
    }

    func setTheme(_ theme: FiltersUITheme) {
        controlsView.setTheme(theme)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private
    @objc private func onLongTap(_ recognizer: UILongPressGestureRecognizer) {
        onLongTap?(recognizer.state)
    }
}
