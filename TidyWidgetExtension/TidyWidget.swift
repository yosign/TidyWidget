import WidgetKit
import SwiftUI

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

struct Provider: TimelineProvider {
    typealias Entry = DreamWidgetData
    let userDefaults = UserDefaults(suiteName: "group.com.yosign.TidyWidget")
    
    func placeholder(in context: Context) -> DreamWidgetData {
        DreamWidgetData(
            title: "我的梦想",
            progress: 0.5,
            imageData: nil,
            lastUpdated: Date()
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DreamWidgetData) -> Void) {
        guard let data = userDefaults?.data(forKey: "currentDream"),
              let dream = try? JSONDecoder().decode(DreamWidgetData.self, from: data) else {
            completion(placeholder(in: context))
            return
        }
        completion(dream)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DreamWidgetData>) -> Void) {
        guard let data = userDefaults?.data(forKey: "currentDream"),
              let dream = try? JSONDecoder().decode(DreamWidgetData.self, from: data) else {
            completion(Timeline(entries: [placeholder(in: context)], policy: .never))
            return
        }
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        completion(Timeline(entries: [dream], policy: .after(nextUpdate)))
    }
}

struct TidyWidgetEntryView: View {
    @AppStorage("showProgress", store: UserDefaults(suiteName: "group.com.yosign.TidyWidget"))
    private var showProgress = true
    
    @AppStorage("showTitle", store: UserDefaults(suiteName: "group.com.yosign.TidyWidget"))
    private var showTitle = true
    
    @AppStorage("showImage", store: UserDefaults(suiteName: "group.com.yosign.TidyWidget"))
    private var showImage = true
    
    var entry: DreamWidgetData
    
    var body: some View {
        VStack(spacing: 8) {
            if showImage, let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .clipped()
            }
            
            if showTitle {
                Text(entry.title)
                    .font(.headline)
                    .lineLimit(1)
            }
            
            if showProgress {
                ProgressView(value: entry.progress)
                    .tint(.blue)
                Text("\(Int(entry.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct TidyWidget: Widget {
    let kind: String = "TidyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TidyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("梦想进度")
        .description("追踪你的梦想实现进度")
        .supportedFamilies([.systemSmall])
    }
} 