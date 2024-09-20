import Foundation
import Alamofire
import UIKit

class ArticleService {
    
    // Function to fetch articles from the API
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let url = "http://110.74.194.123:8080/api/v1/articles"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ApiResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    completion(.success(apiResponse.payload))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Function to upload the image to the server and return the image filename
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://110.74.194.123:8080/api/v1/images/upload"
        
        AF.upload(multipartFormData: { multipartFormData in
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "file", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
        }, to: url)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let imageName = json["imageName"] as? String {
                    completion(.success(imageName)) // Return just the image filename
                } else {
                    completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid response for image upload"])))
                }
            case .failure(let error):
                completion(.failure(error)) // Return error on failure
            }
        }
    }
    
    // Function to post a new article to the API with the image filename
    func postArticle(parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://110.74.194.123:8080/api/v1/articles"
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(.success("Article posted successfully: \(value)"))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
