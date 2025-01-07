import Foundation
import WidgetKit

public struct DreamWidgetData: TimelineEntry, Codable {
    public var date: Date
    public var title: String
    public var progress: Double
    public var imageData: Data?
    public var lastUpdated: Date
    
    public init(title: String, progress: Double, imageData: Data?, lastUpdated: Date) {
        self.date = Date()
        self.title = title
        self.progress = progress
        self.imageData = imageData
        self.lastUpdated = lastUpdated
    }
    
    public static let preview = DreamWidgetData(
        title: "环游世界",
        progress: 0.3,
        imageData: nil,
        lastUpdated: Date()
    )
} 