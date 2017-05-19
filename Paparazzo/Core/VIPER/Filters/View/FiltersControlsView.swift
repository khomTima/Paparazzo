import UIKit

final class FiltersControlsView: UIView {
    
    // MARK: - Subviews
    
    private let discardButton = UIButton()
    private let confirmButton = UIButton()
    
    // MARK: - Constants
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        discardButton.addTarget(
            self,
            action: #selector(onDiscardButtonTap(_:)),
            for: .touchUpInside
        )
        
        confirmButton.addTarget(
            self,
            action: #selector(onConfirmButtonTap(_:)),
            for: .touchUpInside
        )
        
        addSubview(discardButton)
        addSubview(confirmButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        discardButton.size = CGSize.minimumTapAreaSize
        discardButton.center = CGPoint(x: bounds.left + bounds.size.width * 0.25, y: bounds.bottom - 42)
        
        confirmButton.size = CGSize.minimumTapAreaSize
        confirmButton.center = CGPoint(x: bounds.right - bounds.size.width * 0.25, y: discardButton.centerY)
    }
    
    // MARK: - FiltersControlsView
    
    var onDiscardButtonTap: (() -> ())?
    var onConfirmButtonTap: (() -> ())?
    
    
    func setTheme(_ theme: FiltersUITheme) {
        discardButton.setImage(theme.discardIcon, for: .normal)
        confirmButton.setImage(theme.confirmIcon, for: .normal)
    }
    
    // MARK: - Private
    
    @objc private func onDiscardButtonTap(_: UIButton) {
        onDiscardButtonTap?()
    }
    
    @objc private func onConfirmButtonTap(_: UIButton) {
        onConfirmButtonTap?()
    }
}
