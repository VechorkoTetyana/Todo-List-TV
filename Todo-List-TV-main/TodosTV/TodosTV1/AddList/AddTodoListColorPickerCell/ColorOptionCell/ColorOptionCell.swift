import UIKit

struct ColorOption {
    let color: UIColor
    let isSelected: Bool
}

class ColorOptionCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkmarkTodoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        colorView.setCornerRadius(16)
    }

    func configure(with option: ColorOption) {
        colorView.backgroundColor = option.color
        checkmarkTodoView.isHidden = !option.isSelected
    }
}
