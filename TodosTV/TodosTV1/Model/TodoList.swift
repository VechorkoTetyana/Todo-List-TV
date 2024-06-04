import Foundation
import UIKit

struct TodoList {
    let id: String
    var title: String
    var image: String
    var color: UIColor
    var items: [String]
    
    init(id: String = UUID().uuidString, title: String, image: String, color: UIColor, items: [String]) {
        self.id = id
        self.title = title
        self.image = image
        self.color = color
        self.items = items
    }
}
