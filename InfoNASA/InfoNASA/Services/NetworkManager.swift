//
//  NetworkManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 27.11.2021.
//

import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func fetchPictureOfDay(completion: @escaping (PictureOfDay?) -> Void)
}

private enum CategoryPath: String {
    case pictureOfDay = "/planetary/apod"
}

class NetworkManager: NetworkManagerProtocol {
    
    //MARK: - Public methods
    func fetchPictureOfDay(completion: @escaping (PictureOfDay?) -> Void) {
        
        let urlPath = generateUrlPath(for: .pictureOfDay)
        guard let url = URL(string: urlPath) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            let pictureOfDay: PictureOfDay? = self.parseData(with: data)
            
            DispatchQueue.main.async {
                completion(pictureOfDay)
            }
        }.resume()
    }
    
    static func fetchImage(for urlPath: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlPath) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            let uiImage = UIImage(data: imageData)
            DispatchQueue.main.async {
                completion(uiImage)
            }
        }
    }
    
    //MARK: - Private methods
    private func parseData<T: Codable>(with data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func generateUrlPath(for additionalPath: CategoryPath) -> String {
        let apiPath = Constants.share.apiPath
        let apiKey = Constants.share.apiKey
        
        return apiPath + additionalPath.rawValue + "?api_key=\(apiKey)"
    }
    
    private func generateUrlPath(for additionalPath: CategoryPath, with parameters: [String:String]) -> String {
        let apiPath = Constants.share.apiPath
        let apiKey = Constants.share.apiKey
        
        var urlPath = apiPath + additionalPath.rawValue + "?api_key=\(apiKey)"
        
        for (key, value) in parameters {
            urlPath += "&" + key + "=" + value
        }
        
        return urlPath
    }
}
