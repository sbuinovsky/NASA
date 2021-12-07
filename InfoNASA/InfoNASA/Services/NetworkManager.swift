//
//  NetworkManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 27.11.2021.
//

import UIKit
import Alamofire

protocol NetworkManagerProtocol {
    func fetchPictureOfDay(completion: @escaping (Result<PictureOfDay?, NetworkError>) -> Void)
    func fetchPictureOfEPIC(completion: @escaping (Result<[PictureOfEPIC]?, NetworkError>) -> Void)
    func fetchNearEarthObjects(forDateInterval: [String: String], completion: @escaping(Result<[String: [NearEarthObject]]?, NetworkError>) -> Void)
    func getDateInterval(from startDate: Date, to endDate: Date) -> [String: String]
    func getDateInterval(for days: Int) -> [String: String]
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
    
    func fetchNearEarthObjects(forDateInterval parameters: [String: String], completion: @escaping(Result<[String: [NearEarthObject]]?, NetworkError>) -> Void) {
        let urlPath = generateUrlPath(for: .nearEarthObjects, with: parameters)
        
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(_):
                    guard let data = dataResponse.data else { return }
                    let nearEarthObjects: NearEarthObjects? = self.parseData(with: data)
                    let nearEarthObjectsDict = nearEarthObjects?.nearEarthObjects
                    completion(.success(nearEarthObjectsDict))
                case .failure:
                    completion(.failure(.noData))
                }
            }
    }
    
    func getDateInterval(from startDate: Date, to endDate: Date) -> [String: String] {
        let startDate = dateFormatter(with: startDate)
        let endDate = dateFormatter(with: endDate)
        
        return [
            "start_date": startDate,
            "end_date": endDate
        ]
    }
    
    func getDateInterval(for days: Int) -> [String: String] {
        let startDate = Date()
        let timeInterval = TimeInterval(-3600 * 24 * (days - 1))
        let endDate = Date(timeInterval: timeInterval, since: startDate)
        return NetworkManager.shared.getDateInterval(from: startDate, to: endDate)
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
    
    private func dateFormatter(with date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(for imagePath: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else { return }

        if let cachedImage = ImageCache.shared.getImage(url: imagePath) {
            completion(cachedImage)
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            ImageCache.shared.saveImage(url: imagePath, image: image)
            
            DispatchQueue.main.async {
                completion(image)
                return
            }
            
        }.resume()
        
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
