import UIKit

struct TodoList {
    let title: String
    let image: UIImage
    let color: UIColor
    let items: [String]
}

class TodoListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var imageBackground: UIView!
    @IBOutlet private weak var headerView: UIView!
    
    @IBOutlet private weak var addNewItemView: UIView!
    @IBOutlet private weak var addNewItemSafeAreaView: UIView!
    @IBOutlet private weak var plusBtn: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var addBtn: UIButton!

    @IBOutlet weak var addNewItemSaveAreaViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var todoList: TodoList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.setCornerRadius(20)
        
        configure()
        configureTableView()
        configureKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyBoardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        // if the keyboard is hidden
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            addNewItemSaveAreaViewBottomConstraint.constant = 0
            
            tableViewBottomConstraint.constant = 0
        } else {
        // if the keyboard is presented
            addNewItemSaveAreaViewBottomConstraint.constant = -1 * (endFrame.height - view.safeAreaInsets.bottom + 8)
            
            tableViewBottomConstraint.constant = endFrame.height + 8 + addNewItemSafeAreaView.frame.height
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        let cellName = "TodoListItemCell"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    private func configure() {
        titleLbl.text = todoList.title
        iconImageView.image = todoList.image
        headerView.backgroundColor = todoList.color
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
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
