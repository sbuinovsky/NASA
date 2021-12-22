//
//  PODObject.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 20.12.2021.
//

import RealmSwift

class PODObject: Object, Codable {
    @Persisted(primaryKey: true) var date: String
    @Persisted var title: String
    @Persisted var explanation: String
    @Persisted var hdurl: String?
    @Persisted var mediaType: String
    @Persisted var url: String
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case title, url
    }
}
