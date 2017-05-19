import Foundation

final class FiltersListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private let collectionView: UICollectionView
    
    init(filters: [Filter]) {
        self.filters = filters
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        layout.minimumInteritemSpacing = 5.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        
        collectionView.frame = bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var filtersCellData = [FilterCellData]()
    
    var filters: [Filter] {
        didSet {
            filtersCellData = filters.map {
                FilterCellData(previewImage: $0.preview, title: $0.title)
            }
            
            collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout
        if layout is UICollectionViewFlowLayout {
            (layout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 90.0, height: bounds.height)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersCellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
        if cell is FilterCell {
            (cell as! FilterCell).setCellData(filtersCellData[indexPath.row])
        }
        return cell
    }
}
