import Foundation
import UIKit

struct TodoListDTO: Codable {
    
    struct Item: Codable {
        let content: String
        let createDate: Date
    }

    let color: String
    let icon: String
    let title: String
    let items: [String: Item]
    
    init(
        color: String,
        icon: String,
        title: String,
        items: [String: Item]
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
        self.items = try container.decodeIfPresent([String: Item].self, forKey: .items) ?? [:]
    }
}
