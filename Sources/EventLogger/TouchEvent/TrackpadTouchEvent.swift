//
//  TrackpadTouchEvent.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import Foundation

struct TrackpadTouchEvent: TouchEvent {
    let id: String
    let type: TouchType
    let phase: TouchPhase
    let locationX: CGFloat
    let locationY: CGFloat
    let timestamp: Date
    
    let force: CGFloat
    let majorRadius: CGFloat
    let azimuthAngle: CGFloat
}
