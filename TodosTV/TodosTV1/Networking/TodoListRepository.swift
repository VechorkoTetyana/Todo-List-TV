import UIKit
    
    // curl 'https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json'
    
    // curl -X POST -d '{"title": "Groceries", "icon": "avocado", "color": "#4CAF50"}' 'https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json'

// curl -X PATCH -d '{"title": "Volleyball", "icon": "avocado", "color": "#4CAF50"}' 'https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos/-NypAD7QYNx7SGflS1eH.json'


// struct TodoListDTO: Decodable {

// {"name":"-NzPNnPaqEn7RN-7L98w"}

struct AddTodoListResponse: Codable {
    let name: String
}

class TodoListRepository {
    
    typealias TodoListResponse = [String: TodoListDTO]
    
    private lazy var todosUrl = baseUrl.appending(path: "todos.json")
    
    private let baseUrl = URL(string:
        "https://todostv-default-rtdb.europe-west1.firebasedatabase.app/")!
    
    func fetchTodoLists() async throws -> [TodoList] {
//        let url = URL(string:
//                    "https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json")!
        
        let request = URLRequest(url: todosUrl)
//        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
   
        let decoded = try JSONDecoder().decode(TodoListResponse.self, from: data)
        
        return toDomain (decoded)
    }
    func addTodoList(_ todoList: TodoList) async throws -> String {
        var request = URLRequest(url: todosUrl)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(todoList.toData)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(AddTodoListResponse.self, from: data)
        
        return ("Successfully updated list with id \(todoList.id) \(decoded)")
    }
    
    func updateTodoList(_ todoList: TodoList) async throws {
        let payloadDictionary: [String: String] = [
            "color": todoList.color.hexStringOrWhite,
            "title": todoList.title,
            "icon": todoList.image
        ]
        
        var request = URLRequest(
            url: baseUrl
                .appending(path: "todos")
                .appending(path: todoList.id)
        )
        
        request.httpMethod = "PATCH"
        request.httpBody = try JSONSerialization.data(withJSONObject: payloadDictionary)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(TodoListDTO.self, from: data)
        
//        return decoded.toDomain(id: todoList.id)
        print(decoded)
    }
    
    private func toDomain(_ todoListResponse: TodoListResponse) -> [TodoList] {
        var result = [TodoList]()
        
        for(id, todoListDTO) in todoListResponse {
            result.append(todoListDTO
                .toDomain(id: id)
            )
        }
        return result
    }
}

extension TodoListDTO {
    func toDomain(id: String) -> TodoList {
        TodoList(
            id: id,
            title: title,
         // image: UIImage(named: icon + "Icon") ?? UIImage(),
            image: icon,
            color: UIColor(hex: color) ?? .clear,
            items: items
        )
    }
}

extension TodoList {
    var toData: TodoListDTO {
        TodoListDTO(
            color: color.hexStringOrWhite,
            icon: image,
            title: title,
            items: items
        )
    }
}
