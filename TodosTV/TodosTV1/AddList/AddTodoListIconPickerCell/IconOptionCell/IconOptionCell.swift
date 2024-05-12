import UIKit

class IconOptionCell: UICollectionViewCell {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleView.backgroundColor = UIColor(named: "#EBEBEB")
        circleView.setCornerRadius(16)
        circleView.layer.borderWidth = 1
    }

    func configure(with icon: UIImage, isSelected: Bool) {
        iconImageView.image = icon
        circleView.layer.borderColor = isSelected 
        ? UIColor.accent.cgColor
        : UIColor(named: "#DEDEDE")?.cgColor
    }
}
