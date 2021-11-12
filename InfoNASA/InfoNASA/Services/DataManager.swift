//
//  DataManager.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 12.11.2021.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let pictureOfDay: [String: String] = [
        "copyright": "Bernard Miller",
        "date": "2021-11-12",
        "explanation": "The small, northern constellation Triangulum harbors this magnificent face-on spiral galaxy, M33. Its popular names include the Pinwheel Galaxy or just the Triangulum Galaxy. M33 is over 50,000 light-years in diameter, third largest in the Local Group of galaxies after the Andromeda Galaxy (M31), and our own Milky Way. About 3 million light-years from the Milky Way, M33 is itself thought to be a satellite of the Andromeda Galaxy and astronomers in these two galaxies would likely have spectacular views of each other's grand spiral star systems. As for the view from planet Earth, this sharp image shows off M33's blue star clusters and pinkish star forming regions along the galaxy's loosely wound spiral arms. In fact, the cavernous NGC 604 is the brightest star forming region, seen here at about the 4 o'clock position from the galaxy center. Like M31, M33's population of well-measured variable stars have helped make this nearby spiral a cosmic yardstick for establishing the distance scale of the Universe.",
        "hdurl": "https://apod.nasa.gov/apod/image/2111/M33_PS1_CROP_INSIGHT2048.jpg",
        "media_type": "image",
        "service_version": "v1",
        "title": "M33: The Triangulum Galaxy",
        "url": "https://apod.nasa.gov/apod/image/2111/M33_PS1_CROP_INSIGHT1024.jpg"
    ]
    
    private init() {}
}
