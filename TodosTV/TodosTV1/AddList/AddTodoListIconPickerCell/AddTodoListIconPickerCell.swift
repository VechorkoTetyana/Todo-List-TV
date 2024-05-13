import UIKit

class AddTodoListIconPickerCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var icons: [UIImage] = []
    var selectedIcon: UIImage = UIImage()
    
    var didSelectIcon: ((UIImage) -> Void)?
    
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
        collectionView.delegate = self
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

extension AddTodoListIconPickerCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 13, left: 10, bottom: 0, right: 0)
    }
}

extension AddTodoListIconPickerCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectIcon?(icons[indexPath.item])
    }
}

