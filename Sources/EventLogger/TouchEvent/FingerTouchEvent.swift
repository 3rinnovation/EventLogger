//
//  FingerTouchEvent.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import Foundation

public struct FingerTouchEvent: TouchEvent {
    public let id: String
    public let type: TouchType
    public let phase: TouchPhase
    public let locationX: CGFloat
    public let locationY: CGFloat
    public let timestamp: Date

    public let majorRadius: CGFloat
}
