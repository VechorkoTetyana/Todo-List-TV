import Foundation
import UIKit

struct TodoListDTO: Codable {

    let color: String
    let icon: String
    let title: String
    let items: [String]
    
    init(
        color: String,
        icon: String,
        title: String,
        items: [String]
    ) {
        self.color = color
        self.icon = icon
        self.title = title
        self.items = items
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decode(String.self, forKey: .color)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.title = try container.decode(String.self, forKey: .title)
        self.items = try container.decodeIfPresent([String].self, forKey: .items) ?? []
    }
}
