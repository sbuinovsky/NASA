//
//  NearEarthObject.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 18.11.2021.
//

import Foundation

// MARK: - NearEarthObjects
struct NearEarthObjects: Codable {
    let links: NearEarthObjectsLinks
    let elementCount: Int
    let nearEarthObjects: [String: [NearEarthObject]]

    enum CodingKeys: String, CodingKey {
        case links
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
}

// MARK: - NearEarthObjectsLinks
struct NearEarthObjectsLinks: Codable {
    let next, prev, linksSelf: String

    enum CodingKeys: String, CodingKey {
        case next, prev
        case linksSelf = "self"
    }
}

// MARK: - NearEarthObject
struct NearEarthObject: Codable {
    let links: NearEarthObjectLinks
    let id, neoReferenceID, name: String
    let nasaJplURL: String
    let absoluteMagnitudeH: Double
    let estimatedDiameter: EstimatedDiameter
    let isPotentiallyHazardousAsteroid: Bool
    let closeApproachData: [CloseApproachData]
    let isSentryObject: Bool

    enum CodingKeys: String, CodingKey {
        case links, id
        case neoReferenceID = "neo_reference_id"
        case name
        case nasaJplURL = "nasa_jpl_url"
        case absoluteMagnitudeH = "absolute_magnitude_h"
        case estimatedDiameter = "estimated_diameter"
        case isPotentiallyHazardousAsteroid = "is_potentially_hazardous_asteroid"
        case closeApproachData = "close_approach_data"
        case isSentryObject = "is_sentry_object"
    }
    
    var description: String {
        """
        id: \(id)
        
        Potentially Hazardous: \(isPotentiallyHazardousAsteroid ? "yes" : "no" )
        Sentry object: \(isSentryObject ? "yes" : "no" )
        
        Absolute magnitude: \(absoluteMagnitudeH)
        
        Estimated diameter:
        \(estimatedDiameter.description)
        
        Close approach:
        \(closeApproachData.first?.description ?? "")
        
        """
    }
}

// MARK: - CloseApproachDatum
struct CloseApproachData: Codable {
    let closeApproachDate, closeApproachDateFull: String
    let epochDateCloseApproach: Int
    let relativeVelocity: RelativeVelocity
    let missDistance: MissDistance
    let orbitingBody: OrbitingBody

    enum CodingKeys: String, CodingKey {
        case closeApproachDate = "close_approach_date"
        case closeApproachDateFull = "close_approach_date_full"
        case epochDateCloseApproach = "epoch_date_close_approach"
        case relativeVelocity = "relative_velocity"
        case missDistance = "miss_distance"
        case orbitingBody = "orbiting_body"
    }
    
    var description: String {
        """
                Date: \(closeApproachDateFull)
                Orbiting body: \(orbitingBody)
                Relative velocity:
                    km/s: \(relativeVelocity.kilometersPerSecond)
                    km/h: \(relativeVelocity.kilometersPerHour)
                    miles/h: \(relativeVelocity.milesPerHour)
                Miss distance:
                    Astronomical: \(missDistance.astronomical)
                    Lunar: \(missDistance.lunar)
                    Kilometers: \(missDistance.kilometers)
                    Miles: \(missDistance.miles)
        """
    }
}

// MARK: - MissDistance
struct MissDistance: Codable {
    let astronomical, lunar, kilometers, miles: String
}

enum OrbitingBody: String, Codable {
    case earth = "Earth"
}

// MARK: - RelativeVelocity
struct RelativeVelocity: Codable {
    let kilometersPerSecond, kilometersPerHour, milesPerHour: String

    enum CodingKeys: String, CodingKey {
        case kilometersPerSecond = "kilometers_per_second"
        case kilometersPerHour = "kilometers_per_hour"
        case milesPerHour = "miles_per_hour"
    }
}

// MARK: - EstimatedDiameter
struct EstimatedDiameter: Codable {
    let kilometers, meters, miles, feet: Feet
    
    var description: String {
        """
                Kilometers:
                    max: \(kilometers.estimatedDiameterMax)
                    min: \(kilometers.estimatedDiameterMin)
                Meters:
                    max: \(meters.estimatedDiameterMax)
                    min: \(meters.estimatedDiameterMin)
                Miles:
                    max: \(miles.estimatedDiameterMax)
                    min: \(miles.estimatedDiameterMin)
                Feet:
                    max: \(feet.estimatedDiameterMax)
                    min: \(feet.estimatedDiameterMin)
        """
    }
}

// MARK: - Feet
struct Feet: Codable {
    let estimatedDiameterMin, estimatedDiameterMax: Double

    enum CodingKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }
}

// MARK: - NearEarthObjectLinks
struct NearEarthObjectLinks: Codable {
    let linksSelf: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
