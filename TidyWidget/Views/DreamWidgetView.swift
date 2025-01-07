import SwiftUI
import SharedKit

struct DreamWidgetView: View {
    @EnvironmentObject var dreamStore: DreamStore
    @AppStorage("showProgress") private var showProgress = true
    @AppStorage("showTitle") private var showTitle = true
    @AppStorage("showImage") private var showImage = true
    
    var body: some View {
        Form {
            if dreamStore.currentDream == nil {
                Section {
                    Text("请先创建一个梦想")
                        .foregroundColor(.gray)
                }
            } else {
                Section(header: Text("小组件显示设置")) {
                    Toggle("显示进度", isOn: $showProgress)
                    Toggle("显示标题", isOn: $showTitle)
                    Toggle("显示图片", isOn: $showImage)
                }
                
                Section(header: Text("预览")) {
                    VStack {
                        if let dream = dreamStore.currentDream {
                            if showImage, let imageData = dream.imageData, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 120)
                                    .clipped()
                            }
                            
                            if showTitle {
                                Text(dream.title)
                                    .font(.headline)
                                    .padding(.top, showImage ? 8 : 0)
                            }
                            
                            if showProgress {
                                ProgressView(value: dream.progress)
                                    .padding(.top, 4)
                                Text("\(Int(dream.progress * 100))%")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        DreamWidgetView()
    }
} 