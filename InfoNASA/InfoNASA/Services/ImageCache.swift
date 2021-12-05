//
//  ImageCache.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 05.12.2021.
//

import UIKit
import Alamofire

protocol ImageCacheProtocol {
    func getImageFromCache(url: String) -> UIImage?
    func saveImageToCache(url: String, image: UIImage)
}

class ImageCache: ImageCacheProtocol {
    
    static var shared = ImageCache()
    
    private init() {}
    
    private let cacheLifeTime: TimeInterval = 60 * 5 // 5 minutes interval
    var images = [String: UIImage]() //RAM imageCache
    
    private let syncQueue = DispatchQueue(label: "ImageCache.queue", qos: .userInteractive)
    
    private static let cachePath: String = {
        let pathName = "images/"
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName}
        let url = cacheDirectory.appendingPathComponent(pathName)
 
//        Uncomment this if you need to see PATH in console at runtime
//        print("URL PATH: \(url.path)")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return pathName
    }()
    
    func getImageFromCache(url: String) -> UIImage? {
        
        if let cached = images[url] {
            return cached
        } else if let cached = getImageFromFile(url: url) {
            return cached
        }
        
        return nil
    }
    
    func saveImageToCache(url: String, image: UIImage) {
        images[url] = image
        
        if let filePath = getFilePath(url: url),
            let data = image.pngData() {
            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        }
        
    }
    
    private func getFilePath(url: String) -> String? {
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil}
        
        let fileNameURL = url.split(separator: "/").last ?? "default"
        let fileName = fileNameURL.split(separator: "?").first ?? "default"
        
        return cacheDirectory.appendingPathComponent(ImageCache.cachePath + fileName).path
    }
    
    private func getImageFromFile(url: String) -> UIImage? {
        
        guard let filePath = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: filePath),
            let modifiedDate = info[FileAttributeKey.modificationDate] as? Date else { return nil}
        
        let timePassed = Date().timeIntervalSince(modifiedDate)
        
        if timePassed < cacheLifeTime,
            let image = UIImage(contentsOfFile: filePath) {
            images[url] = image
    
            return image
        } else {
            return nil
        }
    }

}
