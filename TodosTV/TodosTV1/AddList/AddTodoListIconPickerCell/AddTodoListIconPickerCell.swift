import UIKit

class AddTodoListIconPickerCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var icons: [UIImage] = []
    var selectedIcon: UIImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    func configure(with icons: [UIImage], selectedIcon: UIImage) {
        self.icons = icons
        self.selectedIcon = selectedIcon
        self.collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "IconOptionCell", bundle: nil), forCellWithReuseIdentifier: "IconOptionCell")
    }
}

extension AddTodoListIconPickerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconOptionCell", for: indexPath) as? IconOptionCell else { return UICollectionViewCell() }
        
        let icon = icons[indexPath.item]
        cell.configure(with: icon, isSelected: icon == selectedIcon)
        
        return cell
    }
}
