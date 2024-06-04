import UIKit

class AddListViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveBtnBottomConstraint: NSLayoutConstraint!
    
    var todoList = TodoList(
        title: "",
        image: "avocado",
        color: .greenTodo,
        items: []
    )
    
    var didSaveList: ((TodoList) -> Void)?
    
    private var colors: [UIColor] = []
    private var selectedColor: UIColor = .clear
    
    private var icons = [String]()
    private var selectedIcon = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.setCornerRadius(20)
        saveBtn.setCornerRadius(14)
        
        fillColors()
        fillIcons()
        
        configureTextField()
        configureTableView()
        setSelectedColor(todoList.color, animated: false)
        setSelectedIcon(todoList.image, animated: false)
        textField.text = todoList.title
        setSaveButton(enabled: isDataValid)
        
        subscribeToKeyboard()
        setupHideKeyBoardGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var isDataValid: Bool {
        guard let text = textField.text else { return false }
        
        return text.count >= 3
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    @objc private func didChangeText() {
       setSaveButton(enabled: isDataValid)
    }
    
    private func setSaveButton(enabled isEnabled: Bool) {
        saveBtn.isUserInteractionEnabled = isEnabled
        
        saveBtn.tintColor = isEnabled ? .white : .accent
        saveBtn.backgroundColor = isEnabled ? .accent : .accent.withAlphaComponent(0.15)
        
    }
    
    private func fillColors() {
                
        self.colors = [
            .greenTodo,
            .redTodo,
            .yellowTodo,
            .blueTodo,
            .purpleTodo,
            .pinkTodo
        ]
    }
    
    private func fillIcons() {
        self.icons = [
            "avocado",
            "vacation",
            "rocket",
            "chores",
            "soccer"
        ]
    }
    
    private func setSelectedColor(_ color: UIColor, animated: Bool) {
        self.selectedColor = color
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.headerView.backgroundColor = color
            }
        } else {
            headerView.backgroundColor = color
        }
    }
    
    private func setSelectedIcon(_ icon: String, animated: Bool) {
        self.selectedIcon = icon
        self.tableView.reloadRows(at: [
            IndexPath(row: 0, section: 1)
        ], with: .none)
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.iconImageView.image = UIImage(named: icon)
            }
        } else {
            self.iconImageView.image = UIImage(named: icon)
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddTodoListColorPickerCell", bundle: nil), forCellReuseIdentifier: "AddTodoListColorPickerCell")
        tableView.register(UINib(nibName: "AddTodoListIconPickerCell", bundle: nil), forCellReuseIdentifier: "AddTodoListIconPickerCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func setupHideKeyBoardGesture() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyBoard)
        )
        
        tap.delegate = self
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            saveBtnBottomConstraint.constant = 0
        } else {
            let buttonBottomMargin = 16 + endFrame.height - view.safeAreaInsets.bottom
            saveBtnBottomConstraint.constant = buttonBottomMargin
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveBtn(_ sender: Any) {
        guard isDataValid, let text = textField.text else { return }
        
        let todoList = TodoList(
            title: text.trimmingCharacters(in: .whitespacesAndNewlines),
            image: selectedIcon,
            color: selectedColor,
            items: []
        )
        
        didSaveList?(todoList)
        
        self.dismiss(animated: true)
    }
}

extension AddListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoListColorPickerCell") as? AddTodoListColorPickerCell else {return UITableViewCell() }
            
            cell.configure(with: colors, selectedColor: selectedColor)
            cell.didSelectColor = { [weak self] selectedColor in
                self?.setSelectedColor(selectedColor, animated: true)
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTodoListIconPickerCell") as? AddTodoListIconPickerCell else {return UITableViewCell() }
            
            cell.configure(with: icons, selectedIcon: selectedIcon)
            cell.didSelectIcon = { selectedIcon in
                self.setSelectedIcon(selectedIcon, animated: true)
            }
           return cell
        }
    }
}

extension AddListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        var view = touch.view
        
        while view != nil {
            if view is UICollectionViewCell {
                return false
            }
            view = view?.superview
        }
        return true
    }
}
