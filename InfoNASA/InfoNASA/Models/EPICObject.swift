//
//  EPICObject.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 20.12.2021.
//

import RealmSwift

class EPICObject: Object, Codable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var caption: String
    @Persisted var image: String
    @Persisted var version: String
    @Persisted var centroidCoordinates: CentroidCoordinates?
    @Persisted var dscovrJ2000Position: J2000Position?
    @Persisted var lunarJ2000Position: J2000Position?
    @Persisted var sunJ2000Position: J2000Position?
    @Persisted var attitudeQuaternions: AttitudeQuaternions?
    @Persisted var date: String
    @Persisted var coords: Coords?
    
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
    
    override var description: String {
        """
        id: \(id)
        
        \(caption)

        Centroid coordinates:
        \(centroidCoordinates?.description ?? "")
        
        Lunar position:
        \(lunarJ2000Position?.description ?? "")
        
        Sun position:
        \(sunJ2000Position?.description ?? "")
        
        Attitude quaternions:
        \(attitudeQuaternions?.description ?? "")
        
        """
    }
}

// MARK: - AttitudeQuaternions
class AttitudeQuaternions: Object, Codable {
    @Persisted var q0: Double
    @Persisted var q1: Double
    @Persisted var q2: Double
    @Persisted var q3: Double
    
    override var description: String {
        """
            q0: \(q0)
            q1: \(q1)
            q2: \(q2)
            q3: \(q3)
        """
    }
}

// MARK: - CentroidCoordinates
class CentroidCoordinates: Object, Codable {
    @Persisted var lat: Double
    @Persisted var lon: Double
    
    override var description: String {
        """
            Latitude: \(lat)
            Longitude: \(lon)
        """
    }
}

// MARK: - Coords
class Coords: Object, Codable {
    @Persisted var centroidCoordinates: CentroidCoordinates?
    @Persisted var dscovrJ2000Position: J2000Position?
    @Persisted var lunarJ2000Position: J2000Position?
    @Persisted var sunJ2000Position: J2000Position?
    @Persisted var attitudeQuaternions: AttitudeQuaternions?
    
    enum CodingKeys: String, CodingKey {
        case centroidCoordinates = "centroid_coordinates"
        case dscovrJ2000Position = "dscovr_j2000_position"
        case lunarJ2000Position = "lunar_j2000_position"
        case sunJ2000Position = "sun_j2000_position"
        case attitudeQuaternions = "attitude_quaternions"
    }
}

// MARK: - J2000Position
class J2000Position: Object, Codable {
    @Persisted var x: Double
    @Persisted var y: Double
    @Persisted var z: Double
    
    override var description: String {
        """
            x: \(x)
            y: \(y)
            z: \(z)
        """
    }
}
