//
//  NearEarthObject.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 18.11.2021.
//

import RealmSwift

// MARK: - NearEarthObjects
class NearEarthObjects: Codable {
    let links: NEOObjectsLinks
    let elementCount: Int
    let nearEarthObjects: [String: [NEOObject]]

    enum CodingKeys: String, CodingKey {
        case links
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
}

// MARK: - NEOObjectsLinks
class NEOObjectsLinks: Object, Codable {
    @Persisted var next: String
    @Persisted var prev: String
    @Persisted var linksSelf: String

    enum CodingKeys: String, CodingKey {
        case next, prev
        case linksSelf = "self"
    }
}

// MARK: - NEOObjectsList
class NEOObjectsList: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var neoObjects: List<NEOObject>
}

// MARK: - NearEarthObject
class NEOObject: Object, Codable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var links: NEOObjectLinks?
    @Persisted var neoReferenceID: String
    @Persisted var name: String
    @Persisted var nasaJplURL: String
    @Persisted var absoluteMagnitudeH: Double
    @Persisted var estimatedDiameter: EstimatedDiameter?
    @Persisted var isPotentiallyHazardousAsteroid: Bool
    @Persisted var closeApproachData: List<CloseApproachData>
    @Persisted var isSentryObject: Bool

    enum CodingKeys: String, CodingKey {
        case id, links
        case neoReferenceID = "neo_reference_id"
        case name
        case nasaJplURL = "nasa_jpl_url"
        case absoluteMagnitudeH = "absolute_magnitude_h"
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
        case isSentryObject = "is_sentry_object"
    }
    
    override var description: String {
        """
        id: \(id)
        
        Potentially Hazardous: \(isPotentiallyHazardousAsteroid ? "yes" : "no" )
        Sentry object: \(isSentryObject ? "yes" : "no" )
        
        Absolute magnitude: \(absoluteMagnitudeH)
        
        Estimated diameter:
        \(estimatedDiameter?.description ?? "")
        
        Close approach:
        \(closeApproachData.first?.description ?? "")
        
        """
    }
}

// MARK: - NearEarthObjectLinks
class NEOObjectLinks: Object, Codable {
    @Persisted var linksSelf: String
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - EstimatedDiameter
class EstimatedDiameter: Object, Codable {
    @Persisted var kilometers: Feet?
    @Persisted var meters: Feet?
    @Persisted var miles: Feet?
    @Persisted var feet: Feet?
    
    override var description: String {
        """
            Kilometers:
                max: \(kilometers?.estimatedDiameterMax ?? 0)
                min: \(kilometers?.estimatedDiameterMin ?? 0)
            Meters:
                max: \(meters?.estimatedDiameterMax ?? 0)
                min: \(meters?.estimatedDiameterMin ?? 0)
            Miles:
                max: \(miles?.estimatedDiameterMax ?? 0)
                min: \(miles?.estimatedDiameterMin ?? 0)
            Feet:
                max: \(feet?.estimatedDiameterMax ?? 0)
                min: \(feet?.estimatedDiameterMin ?? 0)
        """
    }
}

// MARK: - Feet
class Feet: Object, Codable {
    @Persisted var estimatedDiameterMin: Double
    @Persisted var estimatedDiameterMax: Double
    
    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}

// MARK: - CloseApproachDatum
class CloseApproachData: Object, Codable {
    @Persisted var closeApproachDate: String
    @Persisted var closeApproachDateFull: String
    @Persisted var epochDateCloseApproach: Int
    @Persisted var relativeVelocity: RelativeVelocity?
    @Persisted var missDistance: MissDistance?

    enum CodingKeys: String, CodingKey {
        case closeApproachDate = "close_approach_date"
        case closeApproachDateFull = "close_approach_date_full"
        case epochDateCloseApproach = "epoch_date_close_approach"
        case relativeVelocity = "relative_velocity"
        case missDistance = "miss_distance"
    }
    
    override var description: String {
        """
            Date: \(closeApproachDateFull)
            Relative velocity:
                km/s: \(relativeVelocity?.kilometersPerSecond ?? "")
                km/h: \(relativeVelocity?.kilometersPerHour ?? "")
                miles/h: \(relativeVelocity?.milesPerHour ?? "")
            Miss distance:
                Astronomical: \(missDistance?.astronomical ?? "")
                Lunar: \(missDistance?.lunar ?? "")
                Kilometers: \(missDistance?.kilometers ?? "")
                Miles: \(missDistance?.miles ?? "")
        """
    }
}

// MARK: - RelativeVelocity
class RelativeVelocity: Object, Codable {
    @Persisted var kilometersPerSecond: String
    @Persisted var kilometersPerHour: String
    @Persisted var milesPerHour: String
    
    enum CodingKeys: String, CodingKey {
        case kilometersPerSecond = "kilometers_per_second"
        case kilometersPerHour = "kilometers_per_hour"
        case milesPerHour = "miles_per_hour"
    }
}

// MARK: - MissDistance
class MissDistance: Object, Codable {
    @Persisted var astronomical: String
    @Persisted var lunar: String
    @Persisted var kilometers: String
    @Persisted var miles: String
}
