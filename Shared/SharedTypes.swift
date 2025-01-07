import Foundation

// 将所有共享类型放在这个模块中
public struct DreamWidgetData: Codable {
    public var title: String
    public var progress: Double
    public var iconName: String
    public var lastUpdated: Date
    
    public init(title: String, progress: Double, iconName: String, lastUpdated: Date) {
        self.title = title
        self.progress = progress
        self.iconName = iconName
        self.lastUpdated = lastUpdated
    }
    
    public static let preview = DreamWidgetData(
        title: "环游世界",
        progress: 0.3,
        iconName: "airplane.circle.fill",
        lastUpdated: Date()
    )
} 