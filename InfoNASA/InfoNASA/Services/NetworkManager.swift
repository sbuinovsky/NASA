//
//  NetworkManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 27.11.2021.
//

import UIKit
import Alamofire
import SwiftUI

protocol NetworkManagerProtocol {
    func fetchPODObject(completion: @escaping (Result<PODObject, NetworkError>) -> Void)
    func fetchNEOObjects(forDateInterval parameters: [String: String], completion: @escaping(Result<SuccessMessage, NetworkError>) -> Void)
    func fetchEPICObjects(forDate date: Date?, completion: @escaping (Result<SuccessMessage, NetworkError>) -> Void)
    func fetchImage(for imagePath: String, completion: @escaping(UIImage?) -> Void)
    func generateEPICImageURLPath(for picture: EPICObject) -> String
}

private enum CategoryPath: String {
    case POD = "/planetary/apod"
    case NEO = "/neo/rest/v1/feed"
    case EPIC = "/EPIC/api/natural/images"
    case EPICWithDate = "/EPIC/api/natural/date"
}

enum NetworkError: String, Error {
    case invalidURL
    case noData
    case decodingError
}

enum SuccessMessage: String {
    case POD = "PODObject loaded and saved to Realm"
    case NEO = "NEOObjects loaded and saved to Realm"
    case EPIC = "EPICObjects loaded and saved to Realm"
}

class NetworkManager: NetworkManagerProtocol {

    static var shared = NetworkManager()
    
    private init() {}
    
    //MARK: - Public methods
    func fetchPODObject(completion: @escaping (Result<PODObject, NetworkError>) -> Void) {
        let date = DateFormatter.stringFromDate(for: Date.now)
        if let object = StorageManager.shared.realm.object(ofType: PODObject.self, forPrimaryKey: date) {
            completion(.success(object))
        } else {
            let urlPath = generateUrlPath(for: .POD)
            guard let url = URL(string: urlPath) else {
                completion(.failure(.invalidURL))
                return
            }
            
            AF.request(url)
                .validate()
                .responseDecodable(of: PODObject.self) { dataResponse in
                    switch dataResponse.result {
                    case .success(_):
                        guard let data = dataResponse.data else { return }
                        let podObject: PODObject? = self.parseData(with: data)
                        
                        if let podObject = podObject {
                            StorageManager.shared.save(podObject)
                            completion(.success(podObject))
                        } else {
                            completion(.failure(.decodingError))
                        }
                    case .failure:
                        completion(.failure(.noData))
                    }
                }
        }
    }
    
    func fetchNEOObjects(forDateInterval parameters: [String: String], completion: @escaping(Result<SuccessMessage, NetworkError>) -> Void) {
        let urlPath = generateUrlPath(for: .NEO, with: parameters)
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }

        AF.request(url)
            .validate()
            .responseDecodable(of: NEOObjects.self) { dataResponse in
                switch dataResponse.result {
                case .success(_):
                    guard let data = dataResponse.data else { return }
                    let nearEarthObjects: NEOObjects? = self.parseData(with: data)
                    guard let nearEarthObjectsDict = nearEarthObjects?.nearEarthObjects else { return }
                   
                    var neoObjectsLists: [NEOObjectsList] = []
                    for (key, value) in nearEarthObjectsDict {
                        let neoObjectsList = NEOObjectsList()
                        neoObjectsList.date = key
                        neoObjectsList.neoObjects.append(objectsIn: value)
                        neoObjectsLists.append(neoObjectsList)
                    }
                    StorageManager.shared.save(neoObjectsLists)
                    completion(.success(.NEO))
                case .failure:
                    completion(.failure(.noData))
                }
            }
    }
    
    func fetchEPICObjects(forDate date: Date? = nil, completion: @escaping (Result<SuccessMessage, NetworkError>) -> Void) {
        var urlPath = ""
        
        if let date = date {
            urlPath = generateUrlPath(for: .EPICWithDate, forDate: date)
        } else {
            urlPath = generateUrlPath(for: .EPIC)
        }
        
        guard let url = URL(string: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let epicObjects: [EPICObject]? = self.parseArrayData(with: data)
            guard let epicObjects = epicObjects else {
                completion(.failure(.decodingError))
                return
            }
            
            DispatchQueue.main.async {
                StorageManager.shared.save(epicObjects)
                completion(.success(.EPIC))
            }
        }.resume()
    }
    
    func fetchImage(for imagePath: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else { return }

        if let cachedImage = CacheManager.shared.getImage(url: imagePath) {
            completion(cachedImage)
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            
            CacheManager.shared.saveImage(url: imagePath, image: image)
            
            DispatchQueue.main.async {
                completion(image)
                return
            }
            
        }.resume()
        
    }
    
    func generateEPICImageURLPath(for picture: EPICObject) -> String {
        let apiPath = Constants.share.apiPath
        let apiKey = Constants.share.apiKey
        let date = picture.date
        let dateAsPath = date.split(separator: " ")
            .first?
            .replacingOccurrences(of: "-", with: "/") ?? ""
        
        return apiPath + "/EPIC/archive/natural/" + dateAsPath + "/png/" + "\(picture.image).png" + "?api_key=\(apiKey)"
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
    
    private func generateUrlPath(for additionalPath: CategoryPath, forDate date: Date) -> String {
        let apiPath = Constants.share.apiPath
        let apiKey = Constants.share.apiKey
        let date = DateFormatter.stringFromDate(for: date)
        return apiPath + additionalPath.rawValue + "/\(date)" + "?api_key=\(apiKey)"
    }
}
