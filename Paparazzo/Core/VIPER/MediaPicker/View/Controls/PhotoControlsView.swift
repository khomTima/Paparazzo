import UIKit

final class PhotoControlsView: UIView {
    
    struct ModeOptions: OptionSet {
        let rawValue: Int
        
        static let hasRemoveButton  = ModeOptions(rawValue: 1 << 0)
        static let hasCropButton = ModeOptions(rawValue: 1 << 1)
        static let hasFiltersButton  = ModeOptions(rawValue: 1 << 2)
        
        static let allButtons: ModeOptions = [.hasRemoveButton, .hasCropButton, .hasFiltersButton]
    }
    
    // MARK: - Subviews
    
    private let removeButton = UIButton()
    private let cropButton = UIButton()
    private let filtersButton = UIButton()
    
    private var buttons = [UIButton]()
    
    // MARK: UIView
    
    override init(frame: CGRect) {
        self.mode = .allButtons
        super.init(frame: frame)
        
        backgroundColor = .white
        
        removeButton.addTarget(
            self,
            action: #selector(onRemoveButtonTap(_:)),
            for: .touchUpInside
        )
        
        cropButton.addTarget(
            self,
            action: #selector(onCropButtonTap(_:)),
            for: .touchUpInside
        )
        
        filtersButton.addTarget(
            self,
            action: #selector(onFiltersButtonTap(_:)),
            for: .touchUpInside
        )
        
        addSubview(removeButton)
        addSubview(cropButton)
        addSubview(filtersButton)
        
        buttons.append(removeButton)
        buttons.append(cropButton)
        buttons.append(filtersButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let visibleButtons = buttons.filter { $0.isHidden == false }
        visibleButtons.enumerated().forEach { index, button in
            button.size = CGSize.minimumTapAreaSize
            button.center = CGPoint(
                x: round(((CGFloat(index) + 0.5) * bounds.width) / CGFloat(visibleButtons.count)),
                y: bounds.centerY
            )
        }
    }
    
    // MARK: - PhotoControlsView
    
    var onRemoveButtonTap: (() -> ())?
    var onCropButtonTap: (() -> ())?
    var onFiltersButtonTap: (() -> ())?
    var onCameraButtonTap: (() -> ())?
    
    var mode: ModeOptions {
        didSet {
            removeButton.isHidden = !mode.contains(.hasRemoveButton)
            cropButton.isHidden = !mode.contains(.hasCropButton)
            filtersButton.isHidden = !mode.contains(.hasFiltersButton)
            setNeedsLayout()
        }
    }
    
    func setControlsTransform(_ transform: CGAffineTransform) {
        removeButton.transform = transform
        cropButton.transform = transform
    }
    
    func setTheme(_ theme: MediaPickerRootModuleUITheme) {
        removeButton.setImage(theme.removePhotoIcon, for: .normal)
        cropButton.setImage(theme.cropPhotoIcon, for: .normal)
        filtersButton.setImage(theme.filtersIcon, for: .normal)
    }
    
    // MARK: - Private
    
    @objc private func onRemoveButtonTap(_: UIButton) {
        onRemoveButtonTap?()
    }
    
    @objc private func onCropButtonTap(_: UIButton) {
        onCropButtonTap?()
    }
    
    @objc private func onFiltersButtonTap(_: UIButton) {
        onFiltersButtonTap?()
    }
}
