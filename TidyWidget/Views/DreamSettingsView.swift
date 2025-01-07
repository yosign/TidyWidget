import SwiftUI
import PhotosUI
import SharedKit

struct DreamSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dreamStore: DreamStore
    @State private var title: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    let isNewDream: Bool
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                TextField("梦想标题", text: $title)
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack {
                        Text("选择封面图片")
                        Spacer()
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            
            if !isNewDream {
                Section {
                    Button("删除梦想", role: .destructive) {
                        dreamStore.deleteDream()
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle(isNewDream ? "新梦想" : "编辑梦想")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("取消") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    if isNewDream {
                        dreamStore.createDream(title: title, imageData: selectedImageData)
                    } else {
                        dreamStore.updateDream(title: title, imageData: selectedImageData)
                    }
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
        .onAppear {
            if let dream = dreamStore.currentDream {
                title = dream.title
                selectedImageData = dream.imageData
            }
        }
    }
}

#Preview {
    NavigationView {
        DreamSettingsView(isNewDream: false)
    }
} 