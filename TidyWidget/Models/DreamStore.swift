import SwiftUI

@MainActor
class DreamStore: ObservableObject {
    @Published var currentDream: DreamWidgetData?
    private let userDefaults = UserDefaults(suiteName: "group.com.yosign.TidyWidget")
    
    init() {
        loadDream()
    }
    
    private func loadDream() {
        if let data = userDefaults?.data(forKey: "currentDream"),
           let dream = try? JSONDecoder().decode(DreamWidgetData.self, from: data) {
            currentDream = dream
        }
    }
    
    private func saveDream() {
        if let dream = currentDream,
           let data = try? JSONEncoder().encode(dream) {
            userDefaults?.set(data, forKey: "currentDream")
        }
    }
    
    func createDream(title: String, imageData: Data?) {
        let now = Date()
        currentDream = DreamWidgetData(
            title: title,
            progress: 0,
            imageData: imageData,
            lastUpdated: now
        )
        saveDream()
    }
    
    func updateDream(title: String, imageData: Data?) {
        guard var dream = currentDream else { return }
        let now = Date()
        dream.title = title
        dream.imageData = imageData
        dream.lastUpdated = now
        dream.date = now
        currentDream = dream
        saveDream()
    }
    
    func updateProgress(_ progress: Double) {
        guard var dream = currentDream else { return }
        let now = Date()
        dream.progress = progress
        dream.lastUpdated = now
        dream.date = now
        currentDream = dream
        saveDream()
    }
    
    func deleteDream() {
        currentDream = nil
        userDefaults?.removeObject(forKey: "currentDream")
    }
} 