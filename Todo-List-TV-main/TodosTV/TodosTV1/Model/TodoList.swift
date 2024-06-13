import Foundation
import UIKit


struct TodoListItem {
    let id: String
    let content: String
    let createDate: Date
    
    init(id: String = UUID().uuidString, content: String, createDate: Date) {
        self.id = id
        self.content = content
        self.createDate = createDate
    }
}

struct TodoList {
    let id: String
    var title: String
    var image: String
    var color: UIColor
    var items: [TodoListItem]
    
    init(id: String = UUID().uuidString, title: String, image: String, color: UIColor, items: [TodoListItem]) {
        self.id = id
        self.title = title
        self.image = image
        self.color = color
        self.items = items
    }
}
