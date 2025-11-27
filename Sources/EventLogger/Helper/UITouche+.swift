//
//  UITouche+.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import UIKit

extension UITouch.Phase {
    var str: String {
        switch self {
        case .began:
            return "began".uppercased()
        case .moved:
            return "moved".uppercased()
        case .stationary:
            return "stationary".uppercased()
        case .ended:
            return "ended".uppercased()
        case .cancelled:
            return "cancelled".uppercased()
        case .regionMoved:
            return "regionMoved".uppercased()
        case .regionExited:
            return "regionExited".uppercased()
        case .regionEntered:
            return "regionEntered".uppercased()
        default:
            return ""
        }
    }
}

