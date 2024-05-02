import UIKit

class MyTodosViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func present(with todoList: TodoList) {
        let todoListViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
        
        todoListViewController.todoList = todoList
        
        present(todoListViewController, animated: true)
    }
    
    @IBAction func groceriesTapped(_ sender: Any) {
        present(with: TodoList(
            title: "Groceries",
            image: .avocado,
            color: .greenTodo
        ))
    }
    
    @IBAction func vacationTapped(_ sender: Any) {
        present(with: TodoList(
            title: "Vacation",
            image: .vacation,
            color: .redTodo
        ))
    }
    
    @IBAction func choresTapped(_ sender: Any) {
        present(with: TodoList(
            title: "Home Chores",
            image: .chores,
            color: .blueTodo
        ))
     }
}
