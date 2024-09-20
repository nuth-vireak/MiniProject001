import SwiftUI

class PostArticleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedImage: UIImage?
    @Published var isPosting: Bool = false
    @Published var postMessage: String = ""
    
    private let articleService = ArticleService()

    func postArticle() {
        guard !title.isEmpty, !content.isEmpty else {
            postMessage = "Title or Content cannot be empty"
            return
        }
        
        isPosting = true
        postMessage = ""
        
        if let image = selectedImage {
            // Step 1: Upload the image first
            articleService.uploadImage(image: image) { [weak self] result in
                switch result {
                case .success(let imageName):
                    // Step 2: After successful image upload, post the article with the image filename
                    self?.postArticleWithImageName(imageName: imageName)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.isPosting = false
                        self?.postMessage = "Image upload failed: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            // No image selected, post article with a default image filename
            postArticleWithImageName(imageName: "default_image.png")
        }
    }
    
    private func postArticleWithImageName(imageName: String) {
        let parameters: [String: Any] = [
            "title": title,
            "content": content,
            "imageUrl": imageName,  // Only store the image filename
            "author": "Vireak",  // Example author
            "publishedDate": "2024-09-19",
            "views": 0,
            "isPublished": true
        ]
        
        articleService.postArticle(parameters: parameters) { [weak self] result in
            DispatchQueue.main.async {
                self?.isPosting = false
                switch result {
                case .success(let message):
                    self?.postMessage = message
                case .failure(let error):
                    self?.postMessage = "Failed to post article: \(error.localizedDescription)"
                }
            }
        }
    }
}
