import UIKit

class MyTodosViewModel {
    
    private let repository: TodoListRepository
    
    var todoLists: [TodoList] = []
    
    var didFetchLists: () -> ()
    
    init(repository: TodoListRepository = TodoListRepository(), didFetchLists: @escaping (() -> ())) {
        self.repository = repository
        self.didFetchLists = didFetchLists

    }
    
//    var didFetchTodos: (() -> ())?
    
    func fetchTodos() {
//    await repository.fetchTodoLists()
        
        Task {
            do {
                let result = try await repository.fetchTodoLists()
                self.todoLists = result.sorted(by: { $0.title < $1.title })
                
              /*  self.todoLists = result.sorted(by: { todoList1, todoList2 in todoList1.title < todoList2.title })*/
                
                await MainActor.run {
                    self.didFetchLists()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func addTodoList(_ todoList: TodoList) {
        todoLists.insert(todoList, at: 0)
        todoLists = todoLists.sorted(by: { $0.title < $1.title })
        
        Task {
            do {
                let id = try await repository.addTodoList(todoList)
                print("Created a new list with id \(id)")
            } catch {
                print("Couldn't create a new list.")
            }
        }
    }
}
