import UIKit

class MyTodosViewController: UIViewController{
    
    @IBOutlet weak var addListBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
        
    private lazy var viewModel = MyTodosViewModel(
        didFetchLists: { [weak self] in
            self?.tableView.reloadData()
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListBtn.setCornerRadius(14)
        
        configureTableView()
        
        viewModel.fetchTodos()
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let cellName = "TodoListCell"
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        tableView.rowHeight = 44
    }
    
    func present(with todoList: TodoList) {
        let todoListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
        
        todoListViewController.todoList = todoList
        
        present(todoListViewController, animated: true)
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AddListViewController") as! AddListViewController
                
        viewController.didSaveList = { [weak self] todoList in
   //         self?.viewModel.todoLists.insert(todoList, at: 0)
            self?.viewModel.addTodoList(todoList)
            self?.tableView.reloadData()
        }
        present(viewController, animated: true)
    }
}

extension MyTodosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.todoLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell") as? TodoListCell
        else { return UITableViewCell() }
        
        let todoList = viewModel.todoLists[indexPath.row]
        
        cell.configure(with: todoList)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MyTodosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoList = viewModel.todoLists[indexPath.row]
        present(with: todoList)
    }
}

