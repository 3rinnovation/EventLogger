//
//  TouchesWindow.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import UIKit

public class TouchesWindow: UIWindow {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var touchIds: [Int: String] = [:]
    private var keyPressTimes: [String: Date] = [:]
    
    public var touchEventHandler: ((TouchEvent) -> Void)?
    
    public override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        if let touches = event.allTouches {
            for touch in touches {
                let touchEvent = createTouchEvent(touch: touch)
                touchEventHandler?(touchEvent)
                touchEvent.saveToFile()
                
                if touch.phase == .ended || touch.phase == .cancelled {
                    touchIds[touch.hash] = nil
                }
            }
        }
    }
    
    public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        for press in presses {
            if let key = press.key?.characters, !key.isEmpty {
                let pressDownDate = Date()
                keyPressTimes[key] = pressDownDate
                let keyboardEvent = KeyboardEvent(
                    key: key,
                    state: .pressDown,
                    timestamp: pressDownDate,
                    holodTime: nil,
                    inputText: ""
                )
                
                KeyboardEvent.appendToFile(event: keyboardEvent)
            }
        }
    }

    public override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesEnded(presses, with: event)
        for press in presses {
            if let key = press.key?.characters, !key.isEmpty, let pressDownDate = keyPressTimes[key] {
                let pressUpDate = Date()
                let timeSince = pressUpDate.timeIntervalSince(pressDownDate) * 1000
                
                let keyboardEvent = KeyboardEvent(
                    key: key,
                    state: .pressUp,
                    timestamp: pressUpDate,
                    holodTime: (timeSince > 500) ? timeSince : nil,
                    inputText: ""
                )
                keyPressTimes[key] = nil
                
                KeyboardEvent.appendToFile(event: keyboardEvent)
            }
        }
    }
    
    private func createTouchEvent(touch: UITouch) -> TouchEvent {
        let location = touch.location(in: self)
        let time = Date()
        
        var id = touchIds[touch.hash]
        if id == nil {
            id = UUID().uuidString
            touchIds[touch.hash] = id!
        }
        
        switch touch.type {
        case .direct:
            return FingerTouchEvent(
                id: id!,
                type: .direct,
                phase: TouchPhase(rawValue: touch.phase.str) ?? .began,
                locationX: location.x,
                locationY: location.y,
                timestamp: time,
                majorRadius: touch.majorRadius
            )
        case .indirect:
            return TrackpadTouchEvent(
                id: id!,
                type: .trackpad,
                phase: TouchPhase(rawValue: touch.phase.str) ?? .began,
                locationX: location.x,
                locationY: location.y,
                timestamp: time,
                force: touch.force,
                majorRadius: touch.majorRadius,
                azimuthAngle: touch.azimuthAngle(in: self)
            )
        case .pencil, .stylus:
            return PencilTouchEvent(
                id: id!,
                type: .pencil,
                phase: TouchPhase(rawValue: touch.phase.str) ?? .began,
                locationX: location.x,
                locationY: location.y,
                timestamp: time,
                force: touch.force,
                altitudeAngle: touch.altitudeAngle,
                azimuthAngle: touch.azimuthAngle(in: self)
            )
        case .indirectPointer:
            return TrackpadTouchEvent(
                id: id!,
                type: .trackpad,
                phase: TouchPhase(rawValue: touch.phase.str) ?? .began,
                locationX: location.x,
                locationY: location.y,
                timestamp: time,
                force: touch.force,
                majorRadius: touch.majorRadius,
                azimuthAngle: touch.azimuthAngle(in: self)
            )
        default:
            fatalError()
        }
    }
}
