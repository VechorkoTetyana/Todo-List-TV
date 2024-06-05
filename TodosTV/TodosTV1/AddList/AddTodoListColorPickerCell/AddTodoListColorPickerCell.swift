import UIKit

class AddTodoListColorPickerCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var colors: [UIColor] = []
    private var selectedColor: UIColor = .clear
    
    var didSelectColor: ((UIColor) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }
    
    func configure(with colors: [UIColor], selectedColor: UIColor) {
        
        self.colors = colors
        self.selectedColor = selectedColor
        self.collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ColorOptionCell", bundle: nil), forCellWithReuseIdentifier: "ColorOptionCell")
    }
}

extension AddTodoListColorPickerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorOptionCell", for: indexPath) as? ColorOptionCell  else { return UICollectionViewCell() }
        
        let color = colors[indexPath.item]
        
        let option = ColorOption(
            color: color,
            isSelected: color.hexString == selectedColor.hexString
        )
        
        cell.configure(with: option)
        
        return cell
    }
}

extension AddTodoListColorPickerCell: UICollectionViewDelegateFlowLayout {
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

extension AddTodoListColorPickerCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.item]
        didSelectColor?(selectedColor)
    }
}
