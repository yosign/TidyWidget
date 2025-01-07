import SwiftUI
import SharedKit

struct DreamProgressView: View {
    @EnvironmentObject var dreamStore: DreamStore
    @State private var showingAddSheet = false
    @State private var progress: Double = 0.0
    
    var body: some View {
        Group {
            if dreamStore.currentDream == nil {
                VStack(spacing: 20) {
                    Image(systemName: "star.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("开始追逐你的梦想")
                        .font(.title2)
                    
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Label("添加梦想", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    NavigationView {
                        DreamSettingsView(isNewDream: true)
                    }
                }
            } else if let dream = dreamStore.currentDream {
                ScrollView {
                    VStack(spacing: 20) {
                        // 头部信息
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dream.title)
                                    .font(.title)
                                    .bold()
                                Text("上次更新: \(dream.lastUpdated.formatted(.dateTime))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                showingAddSheet = true
                            }) {
                                Image(systemName: "gear")
                                    .font(.title2)
                            }
                        }
                        .padding()
                        
                        // 进度圆环
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                                .frame(width: 200, height: 200)
                            
                            Circle()
                                .trim(from: 0, to: dream.progress)
                                .stroke(
                                    .linearGradient(
                                        colors: [.blue, .blue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                            
                            VStack {
                                Text("\(Int(dream.progress * 100))%")
                                    .font(.system(size: 40, weight: .bold))
                                Text("完成")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        
                        // 进度调整滑块
                        VStack(alignment: .leading, spacing: 8) {
                            Text("调整进度")
                                .font(.headline)
                            
                            Slider(value: Binding(
                                get: { progress },
                                set: { newValue in
                                    progress = newValue
                                    dreamStore.updateProgress(newValue)
                                }
                            ), in: 0...1, step: 0.01)
                            .tint(.blue)
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
                .sheet(isPresented: $showingAddSheet) {
                    NavigationView {
                        DreamSettingsView(isNewDream: false)
                    }
                }
            }
        }
        .onAppear {
            if let dream = dreamStore.currentDream {
                progress = dream.progress
            }
        }
    }
}

#Preview {
    NavigationView {
        DreamProgressView()
    }
} 