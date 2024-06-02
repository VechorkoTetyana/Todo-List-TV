import UIKit
    
    // curl 'https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json'
    
    // curl -X POST -d '{"title": "Groceries", "icon": "avocado", "color": "#4CAF50"}' 'https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json'

// struct TodoListDTO: Decodable {

// {"name":"-NzPNnPaqEn7RN-7L98w"}

struct AddTodoListResponse: Codable {
    let name: String
}

class TodoListRepository {
    
    typealias TodoListResponse = [String: TodoListDTO]
    
    private let todosUrl = URL(string:
        "https://todostv-default-rtdb.europe-west1.firebasedatabase.app/todos.json")!
    
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
        
        return decoded.name
    }
    
    private func toDomain(_ todoListResponse: TodoListResponse) -> [TodoList] {
        var result = [TodoList]()
        
        for(_, todoListDTO) in todoListResponse {
            result.append(todoListDTO.toDomain)
        }
        return result
    }
}

extension TodoListDTO {
    var toDomain: TodoList {
        TodoList(
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
            color: color.hexString ?? "#FFFFFF",
            icon: image,
            title: title,
            items: items
        )
    }
}
