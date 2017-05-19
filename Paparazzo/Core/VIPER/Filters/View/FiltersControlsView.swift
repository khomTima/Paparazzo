import UIKit

final class FiltersControlsView: UIView {
    
    // MARK: - Subviews
    
    private let discardButton = UIButton()
    private let confirmButton = UIButton()
    private var filtersListView: FiltersListView
    
    // MARK: - Constants
    
    // MARK: - Init
    
    init(filters: [Filter]? = nil) {
        filtersListView = FiltersListView(filters: filters ?? [])
        
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
        
        addSubview(filtersListView)
        addSubview(discardButton)
        addSubview(confirmButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        filtersListView.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: 140.0
        )
        
        discardButton.layout(
            left: bounds.size.width * 0.25,
            top: filtersListView.bottom,
            width: CGSize.minimumTapAreaSize.width,
            height: CGSize.minimumTapAreaSize.height
        )
        
        confirmButton.layout(
            top: discardButton.top,
            bottom: discardButton.bottom,
            right: bounds.width - bounds.size.width * 0.25,
            width: CGSize.minimumTapAreaSize.width
        )
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
