//
//  EPICPicture.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 21.11.2021.
//

import Foundation

struct PictureOfEPIC: Codable {
    let id: String
    var image: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "identifier"
        case image, date
    }
}
