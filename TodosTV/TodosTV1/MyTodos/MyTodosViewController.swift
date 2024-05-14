import UIKit

class MyTodosViewController: UIViewController{
    
    @IBOutlet weak var addListBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var lists: [TodoList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListBtn.setCornerRadius(14)
        
        lists = myTodoLists()
        configureTableView()
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
    
    private func myTodoLists() -> [TodoList] {
        var lists = [TodoList]()
        
        lists.append(TodoList(
            title: "Groceries",
            image: .avocadoIcon,
            color: .greenTodo,
            items: groceriesItems()
        ))
        
        lists.append(TodoList(
            title: "Vacation",
            image: .vacationIcon,
            color: .redTodo,
            items: vacationItems()
        ))
        
        lists.append(TodoList(
            title: "Home Chores",
            image: .choresIcon,
            color: .blueTodo,
            items: choresItems()
        ))
        
        return lists
    }
    
    private func groceriesItems() -> [String] {
        var items = [String]()
        items.append("Whole wheat bread")
        items.append("Almond milk")
        items.append("Cage-free eggs")
        items.append("Fresh spinach")
        items.append("Greek yogurt")
        items.append("Quinoa")
        items.append("Avocados")
        items.append("Cherry tomatoes")
        items.append("Organic chicken breast")
        items.append("Ground turmeric")
        items.append("Almonds")
        items.append("Dark chocolate")

        return items
    }
    
    private func vacationItems() -> [String] {
        var items = [String]()
        items.append("Check weather")
        items.append("Accommodation")
        items.append("Daily Plan")
        items.append("Passport and visa requirements")
        items.append("Arrange pet care")
        items.append("Exchange currency")
        items.append("Confirm airport transfers")
        items.append("Flight tickets")
        items.append("Restaurant reservations")
        
        return items
    }
    
    private func choresItems() -> [String] {
        var items = [String]()
        items.append("Vacuum the living room")
        items.append("Mop kitchen floors")
        items.append("Clean windows in the dining area")
        items.append("Dust all surfaces")
        items.append("Organize the garage")
        
        return items
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AddListViewController") as! AddListViewController
                
        viewController.didSaveList = { [weak self] todoList in
            self?.lists.insert(todoList, at: 0)
            self?.tableView.reloadData()
        }
        present(viewController, animated: true)
    }
}

extension MyTodosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell") as? TodoListCell
        else { return UITableViewCell() }
        
        let todoList = lists[indexPath.row]
        
        cell.configure(with: todoList)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MyTodosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoList = lists[indexPath.row]
        present(with: todoList)
    }
}

