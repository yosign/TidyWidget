import Foundation
import WidgetKit

struct DreamWidgetData: TimelineEntry, Codable {
    var date: Date
    var title: String
    var progress: Double
    var imageData: Data?
    var lastUpdated: Date
    
    init(title: String, progress: Double, imageData: Data?, lastUpdated: Date) {
        self.date = Date()
        self.title = title
        self.progress = progress
        self.imageData = imageData
        self.lastUpdated = lastUpdated
    }
    
    static let preview = DreamWidgetData(
        title: "环游世界",
        progress: 0.3,
        imageData: nil,
        lastUpdated: Date()
    )
} 