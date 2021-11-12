//
//  PictureOfDay.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import Foundation

struct PictureOfDay {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let title: String
    let url: String
}

extension PictureOfDay {
    static func getPicture() -> PictureOfDay {
        let dataManager = DataManager.shared
        let data = dataManager.pictureOfDay
        let pictureOfDay = PictureOfDay(
            copyright: data["copyright"] ?? "",
            date: data["date"] ?? "",
            explanation: data["explanation"] ?? "",
            hdurl: data["hdurl"] ?? "",
            media_type: data["media_type"] ?? "",
            title: data["title"] ?? "",
            url: data["url"] ?? ""
        )
        
        return pictureOfDay
    }
}
