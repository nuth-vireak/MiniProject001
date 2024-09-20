import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostArticleViewModel()
    @State private var isImagePickerPresented = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Post Article")
                    .font(.title)
                    .bold()
                
                // Image section
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    if let selectedImage = viewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                }
                
                // Title TextField
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                    TextField("Enter Title", text: $viewModel.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                }
                
                // Content TextEditor
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                    TextEditor(text: $viewModel.content)
                        .frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding(.bottom, 20)
                }
                
                // Post Button
                Button(action: viewModel.postArticle) {
                    if viewModel.isPosting {
                        ProgressView()
                    } else {
                        Text("Post")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                
                // Show success or error message
                if !viewModel.postMessage.isEmpty {
                    Text(viewModel.postMessage)
                        .foregroundColor(viewModel.postMessage.contains("Success") ? .green : .red)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }
}
