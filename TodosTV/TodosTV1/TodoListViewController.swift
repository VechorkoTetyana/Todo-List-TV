import UIKit

struct TodoList {
    let title: String
    let image: UIImage
    let color: UIColor
}

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var headerView: UIView!
    
    var todoList: TodoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.layer.cornerRadius = 20
        imageBackground.layer.masksToBounds = true
        
        configure()
        
    }
    
    func configure() {
        titleLbl.text = todoList.title
        iconImageView.image = todoList.image
        headerView.backgroundColor = todoList.color
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
