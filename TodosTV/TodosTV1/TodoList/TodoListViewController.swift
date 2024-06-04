import UIKit

class TodoListViewModel {
    
    private let repository: TodoListRepository
    
    var todoList: TodoList!

    init(repository:
         TodoListRepository = TodoListRepository(),
         todoList: TodoList
    ) {
        self.repository = repository
        self.todoList = todoList
    }
    
    func update(with todoList: TodoList) {
        self.todoList.update(with: todoList)
        
        Task {
            do {
                try await repository.updateTodoList(self.todoList)
            } catch {
                print(error)
            }
        }
    }
    
    func delete() {
        Task {
            do {
                try await repository.deleteTodoList(with: todoList.id)
            } catch {
                print(error)
            }
        }
    }
}

extension TodoList {
    mutating func update(with todoList: TodoList) {
       title = todoList.title
       color = todoList.color
       image = todoList.image
    }
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
        
    @IBOutlet weak var textFieldLeftConstraint: NSLayoutConstraint!
    
    var viewModel: TodoListViewModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.setCornerRadius(20)
        
        configure()
        configureTableView()
        configureKeyboard()
        configureAddItemView()
        configureTextField()
        
        setAddNewItenButton(enabled: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
    }
    
    private var isNewItemValid: Bool {
        guard let text = textField.text else { return false }
        return !text.isEmpty
    }
    
    @objc private func didChangeText() {
        setAddNewItenButton(enabled: isNewItemValid)
    }
    
    private func setAddNewItenButton(enabled isEnabled: Bool) {
//        guard let text = textField.text else { return }
        addBtn.isUserInteractionEnabled = isEnabled
        addBtn.tintColor = isEnabled ? .accent : UIColor(hex: "#737373")?.withAlphaComponent(0.5)
    }
    
    private func configureAddItemView() {
        addNewItemView.layer.masksToBounds = false
        //      addNewItemView.setCornerRadius(<#T##radius: CGFloat##CGFloat#>)
        addNewItemView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        addNewItemView.layer.cornerRadius = 15
        addNewItemView.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    //    addNewItemView.layer.shadowOffset = CGSize(width: 0, height: 0) the same as --->>>
        addNewItemView.layer.shadowOffset = .zero
        addNewItemView.layer.shadowRadius = 18.5
        addNewItemView.layer.shadowPath = UIBezierPath(roundedRect: addNewItemView.bounds, cornerRadius: addNewItemView.layer.cornerRadius).cgPath
        addNewItemView.layer.shadowOpacity = 1
        
        addNewItemSafeAreaView.setCornerRadius(15)
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
        
        let animationCurveRawNumber = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSNumber
        let animatedCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animatedCurveRaw)
        
        let isKeyBoardHidden = endFrame.origin.y >= UIScreen.main.bounds.size.height
        
        // if the keyboard is hidden
        if isKeyBoardHidden {
            addNewItemSaveAreaViewBottomConstraint.constant = 0
  //          tableViewBottomConstraint.constant = 0
            textFieldLeftConstraint.constant = 48
        } else {
        // if the keyboard is presented
            addNewItemSaveAreaViewBottomConstraint.constant = -1 * (endFrame.height - view.safeAreaInsets.bottom + 8)
   //         tableViewBottomConstraint.constant = endFrame.height + 8 + addNewItemSafeAreaView.frame.height
            textFieldLeftConstraint.constant = 16
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.plusBtn.alpha = isKeyBoardHidden ? 1 : 0
            self.addBtn.alpha = isKeyBoardHidden ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cellName = "TodoListItemCell"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    private func configure() {
        titleLbl.text = viewModel.todoList.title
        iconImageView.image = UIImage(named: viewModel.todoList.image)
        headerView.backgroundColor = viewModel.todoList.color
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        guard isNewItemValid, let text = textField.text else { return }
        
        let itemTrimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.todoList.items.append(itemTrimmed)
        
        let indexPath = IndexPath(row: viewModel.todoList.items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        textField.text = ""
        setAddNewItenButton(enabled: false)
    }
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        let sheet = UIAlertController(
            title: "More Actions",
            message: "What do you want to do?",
            preferredStyle: .actionSheet
        )
        
        sheet.addAction(UIAlertAction(
            title: "Edit",
            style: .default,
            handler: { [weak self] _ in
                self?.presentEdit()
            }
        ))
        
        sheet.addAction(UIAlertAction(
            title: "Delete List",
            style: .destructive,
            handler: { [weak self] _ in
             // guard let `self` = self else { return } if strong needed or smth...
                self?.presentDeletePrompt()
            }
        ))
        
        sheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(sheet, animated: true)
    }
    
    private func presentDeletePrompt() {
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Deleting the app will forever remove all the items and the list itself",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .default,
            handler: { [weak self] _ in
                self?.deleteListAndDismiss()
            }
        ))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        self.present(alert, animated: true)
    }
    
    private func presentEdit() {
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AddListViewController") as! AddListViewController
        
        vc.todoList = viewModel.todoList
        
        vc.didSaveList = { [weak self] todoList in
            self?.updateList(todoList)
        }
        
        self.present(vc, animated: true)
    }
    
    private func updateList(_ todoList: TodoList) {
   //   viewModel.todoList.update(with: todoList)
        viewModel.update(with: todoList)

        
        configure()
    }
    
    private func deleteListAndDismiss() {
        viewModel.delete()
        self.dismiss(animated: true)
    }
}

extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todoList.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItemCell") as? TodoListItemCell
        else { return UITableViewCell() }
        
        let item = viewModel.todoList.items[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

extension TodoListViewController: UIScrollViewDelegate, UITableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
