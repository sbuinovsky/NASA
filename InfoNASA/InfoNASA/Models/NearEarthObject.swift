//
//  NearEarthObject.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 18.11.2021.
//

import Foundation

struct NearEarthObject {
    let id: Int
    let neoReferenceId: String
    let name: String
    let nasaJplUrl: String
    let absoluteMagnitudeH: Double
    let estimatedDiameterMin: Double
    let estimatedDiameterMax: Double
}

extension NearEarthObject {
    static func getObjects() -> [NearEarthObject] {
        let dataManager = DataManager.shared
        let data = dataManager.nearEarthObjects
        var objects: [NearEarthObject] = []
        for item in data {
            let id = Int(item["id"] ?? "") ?? 0
            let neoReferenceId = item["neo_reference_id"] ?? ""
            let name = item["name"] ?? ""
            let nasaJplUrl = item["nasa_jpl_url"] ?? ""
            let absoluteMagnitudeH = Double(item["absolute_magnitude_h"] ?? "") ?? 0
            let estimatedDiameterMin = Double(item["estimated_diameter_min"] ?? "") ?? 0
            let estimatedDiameterMax = Double(item["estimated_diameter_max"] ?? "") ?? 0
            
            let object = NearEarthObject(id: id,
                                         neoReferenceId: neoReferenceId,
                                         name: name,
                                         nasaJplUrl: nasaJplUrl,
                                         absoluteMagnitudeH: absoluteMagnitudeH,
                                         estimatedDiameterMin: estimatedDiameterMin,
                                         estimatedDiameterMax: estimatedDiameterMax)
            objects.append(object)
        }
        
        return objects
    }
}
