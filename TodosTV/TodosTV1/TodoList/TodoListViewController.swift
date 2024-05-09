import UIKit

struct TodoList {
    let title: String
    let image: UIImage
    let color: UIColor
    let items: [String]
}

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var headerView: UIView!
    
    var todoList: TodoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.setCornerRadius(20)
        
        configure()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        let cellName = "TodoListItemCell"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
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

extension UIView {
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItemCell") as? TodoListItemCell
        else { return UITableViewCell() }
        
        let item = todoList.items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}
