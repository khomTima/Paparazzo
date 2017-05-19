import Foundation

final class FilterCell: UICollectionViewCell {
    private let previewImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.layer.shouldRasterize = true
        previewImageView.layer.rasterizationScale = UIScreen.main.nativeScale
        previewImageView.layer.cornerRadius = 5.0

        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleSize = titleLabel.sizeThatFits(bounds.size)
        titleLabel.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: titleSize.height
        )
        
        previewImageView.layout(
            top: titleLabel.bottom + 10.0,
            bottom: bounds.bottom,
            left: bounds.left,
            width: bounds.width
        )
    }
    
    public func setCellData(_ cellData: FilterCellData) {
        previewImageView.image = cellData.previewImage
        titleLabel.text = cellData.title
    
        setNeedsLayout()
    }
}
