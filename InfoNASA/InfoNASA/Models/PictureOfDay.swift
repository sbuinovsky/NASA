//
//  PictureOfDay.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import Foundation

struct PictureOfDay: Codable {
    let date: String
    let explanation: String
    let hdurl: String
    let mediaType: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case title, url
    }
}
