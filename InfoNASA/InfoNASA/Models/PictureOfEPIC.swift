//
//  EPICPicture.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 21.11.2021.
//

import Foundation

struct PictureOfEPIC {
    let id: Int
    let imageName: String
    let date: String
}

extension PictureOfEPIC {
    static func getPictures() -> [PictureOfEPIC] {
        let dataManager = DataManager.shared
        let data = dataManager.EPICData
        var pictures: [PictureOfEPIC] = []
        for item in data {
            let id = Int(item["identifier"] ?? "") ?? 0
            let imageName = item["image"] ?? ""
            let date = item["date"] ?? ""
            
            let picture = PictureOfEPIC(id: id, imageName: imageName, date: date)
            
            pictures.append(picture)
        }
        
        return pictures
    }
}
