import UIKit

class AudioListItemCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with item: String) {
        titleLbl.text = item
        
    }
}
