//
//  EPICPicture.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 21.11.2021.
//

import Foundation

struct PictureOfEPIC: Codable {
    let id, caption, image, version: String
    let centroidCoordinates: CentroidCoordinates
    let dscovrJ2000Position, lunarJ2000Position, sunJ2000Position: J2000Position
    let attitudeQuaternions: AttitudeQuaternions
    let date: String
    let coords: Coords

    enum CodingKeys: String, CodingKey {
        case id = "identifier"
        case caption, image, version
        case centroidCoordinates = "centroid_coordinates"
        case dscovrJ2000Position = "dscovr_j2000_position"
        case lunarJ2000Position = "lunar_j2000_position"
        case sunJ2000Position = "sun_j2000_position"
        case attitudeQuaternions = "attitude_quaternions"
        case date, coords
    }
    
    var description: String {
        """
        id: \(id)
        
        \(caption)

        Centroid coordinates:
        \(centroidCoordinates.description)
        
        Lunar position:
        \(lunarJ2000Position.description)
        
        Sun position:
        \(sunJ2000Position.description)
        
        Attitude quaternions:
        \(attitudeQuaternions.description)
        
        """
    }
}

// MARK: - AttitudeQuaternions
struct AttitudeQuaternions: Codable {
    let q0, q1, q2, q3: Double
    
    var description: String {
        """
            q0: \(q0)
            q1: \(q1)
            q2: \(q2)
            q3: \(q3)
        """
    }
}

// MARK: - CentroidCoordinates
struct CentroidCoordinates: Codable {
    let lat, lon: Double
    
    var description: String {
        """
            Latitude: \(lat)
            Longitude: \(lon)
        """
    }
}

// MARK: - Coords
struct Coords: Codable {
    let centroidCoordinates: CentroidCoordinates
    let dscovrJ2000Position, lunarJ2000Position, sunJ2000Position: J2000Position
    let attitudeQuaternions: AttitudeQuaternions

    enum CodingKeys: String, CodingKey {
        case centroidCoordinates = "centroid_coordinates"
        case dscovrJ2000Position = "dscovr_j2000_position"
        case lunarJ2000Position = "lunar_j2000_position"
        case sunJ2000Position = "sun_j2000_position"
        case attitudeQuaternions = "attitude_quaternions"
    }
}

// MARK: - J2000Position
struct J2000Position: Codable {
    let x, y, z: Double
    
    var description: String {
        """
            x: \(x)
            y: \(y)
            z: \(z)
        """
    }
}
