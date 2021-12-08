//
//  Animation.swift
//  InfoNASA
//
//  Created by Станислав Буйновский on 28.11.2021.
//

import UIKit

extension UIView {
    
    enum AnimationKeyPath: String {
        case opacity = "opacity"
    }
    
    func animate(animation: AnimationKeyPath, withDuration duration: Double, repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: animation.rawValue)
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.fromValue = 0
        animation.toValue = 1
        
        layer.add(animation, forKey: nil)
    }
}
