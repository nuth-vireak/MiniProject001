import SwiftUI
import Combine

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var errorMessage: String? = nil
    
    private let articleService = ArticleService()
    private var timer: AnyCancellable?
    
    func fetchArticles() {
        articleService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.articles = articles
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func startFetchingDataInRealTime() {
        timer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchArticles()
            }
    }
    
    func stopFetchingData() {
        timer?.cancel()
    }
}
