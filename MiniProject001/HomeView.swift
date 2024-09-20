import SwiftUI
import Kingfisher

// View to display the list of articles
struct HomeView: View {
    @StateObject private var viewModel = ArticleViewModel()
    @State private var search: String = ""
    
    let imageBaseURL = "http://110.74.194.123:8080/api/v1/images?fileName=" // Your image base URL
    
    var body: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                // Display error message if there is any issue with data fetching
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                // List of articles loaded from the API
                List(viewModel.articles) { article in
                    HStack(spacing: 15) {
                        // Prepend the base URL to the image filename
                        KFImage(URL(string: "\(imageBaseURL)\(article.imageUrl)"))
                            .placeholder {
                                Color.gray // Placeholder while image is loading
                                    .frame(width: 80, height: 80)
                            }
                            .resizable()
                            .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(article.title)
                                .font(.headline)
                                .lineLimit(1)
                            Text(article.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            HStack {
                                Text(article.author)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(article.publishedDate)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .searchable(text: $search)
            }
        }
        .onAppear {
            viewModel.startFetchingDataInRealTime() // Start real-time data fetching when view appears
        }
        .onDisappear {
            viewModel.stopFetchingData() // Stop the timer when the view disappears
        }
    }
}
