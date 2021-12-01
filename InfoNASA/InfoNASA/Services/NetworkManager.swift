//
//  NetworkManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 27.11.2021.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchPictureOfDay(completion: @escaping (Result<PictureOfDay?, NetworkError>) -> Void)
    func fetchPictureOfEPIC(completion: @escaping (Result<[PictureOfEPIC]?, NetworkError>) -> Void)
}

private enum CategoryPath: String {
    case pictureOfDay = "/planetary/apod"
    case pictureOfEPIC = "/EPIC/api/natural/images"
    case nearEarthObjects = "/neo/rest/v1/feed"
}

enum NetworkError: String, Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager: NetworkManagerProtocol {
    
    static var shared = NetworkManager()
    
    private init() {}
    
    //MARK: - Public methods
    func fetchPictureOfDay(completion: @escaping (Result<PictureOfDay?, NetworkError>) -> Void) {
        
        let urlPath = generateUrlPath(for: .pictureOfDay)
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no description")
                return
            }
            
            let pictureOfDay: PictureOfDay? = self.parseData(with: data)
            
            DispatchQueue.main.async {
                completion(.success(pictureOfDay))
            }
        }.resume()
    }
    
    func fetchPictureOfEPIC(completion: @escaping (Result<[PictureOfEPIC]?, NetworkError>) -> Void) {
        let urlPath = generateUrlPath(for: .pictureOfEPIC)
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "")
                return
            }
            
            let pictureObjects: [PictureOfEPIC]? = self.parseArrayData(with: data)
            
            DispatchQueue.main.async {
                completion(.success(pictureObjects))
            }
        }.resume()
    }
    
    func fetchNearEarthObjects(completion: @escaping(Result<[String: [NearEarthObject]]?, NetworkError>) -> Void) {
        let parameters = [
            "start_date": "2021-10-01",
            "end_date":"2021-10-05"
        ]
        
        let urlPath = generateUrlPath(for: .nearEarthObjects, with: parameters)
        
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let data = dataResponse.data else { return }
                    let nearEarthObjects: NearEarthObjects? = self.parseData(with: data)
                    let nearEarthObjectsDict = nearEarthObjects?.nearEarthObjects
                    completion(.success(nearEarthObjectsDict))
                case .failure:
                    completion(.failure(.noData))
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
    
    private func parseArrayData<T: Codable>(with data: Data) -> [T]? {
        let decoder = JSONDecoder()
        
        do {
            let objects = try decoder.decode([T].self, from: data)
            return objects
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

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(for imagePath: String, completion: @escaping(Data) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: imagePath) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func generateEPICImageURLPath(for picture: PictureOfEPIC) -> String {
        let apiPath = Constants.share.apiPath
        let apiKey = Constants.share.apiKey
        let date = picture.date
        let dateAsPath = date.split(separator: " ")
            .first?
            .replacingOccurrences(of: "-", with: "/") ?? ""
        
        return apiPath + "/EPIC/archive/natural/" + dateAsPath + "/png/" + "\(picture.image).png" + "?api_key=\(apiKey)"
    }
}
