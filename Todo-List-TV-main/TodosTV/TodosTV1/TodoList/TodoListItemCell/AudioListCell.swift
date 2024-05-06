import UIKit

class AudioListCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(with audioList: AudioList) {
        iconImageView.image = audioList.image
        titleLbl.text = "\(audioList.title) (\(audioList.items.count))"
    }
}
