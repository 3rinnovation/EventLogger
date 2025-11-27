//
//  TouchEvent.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import Foundation

enum TouchType: String, Codable {
    case direct = "DIRECT"
    case trackpad = "TRACKPAD"
    case pencil = "PENCIL"
}

enum TouchPhase: String, Codable {
    case began = "BEGAN"
    case moved = "MOVED"
    case stationary = "STATIONARY"
    case ended = "ENDED"
    case cancelled = "CANCELLED"
    case regionEntered = "REGION_ENTERED"
    case regionMoved = "REGION_MOVED"
    case regionExited = "REGION_EXITED"
}

protocol TouchEvent: Codable {
    var id: String { get }
    var type: TouchType { get }
    var phase: TouchPhase { get }
    var locationX: CGFloat { get }
    var locationY: CGFloat { get }
    var timestamp: Date { get }
}

extension TouchEvent {
    func saveToFile() {
        let type = self.type
        let fileName = "touch_events_\(type.rawValue).json"
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        
        do {
            let jsonData = try JSONEncoder.iso8601Encoder().encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)! + "\n"  // 한 줄씩 저장
            
            if let fileHandle = FileHandle(forWritingAtPath: directory.path) {
                fileHandle.seekToEndOfFile() // 파일 끝으로 이동
                fileHandle.write(jsonString.data(using: .utf8)!)
                fileHandle.closeFile()
            } else {
                // 파일이 없으면 새로 생성
                try jsonString.write(to: directory, atomically: true, encoding: .utf8)
            }
        } catch {
            print("파일 저장 실패: \(error)")
        }
    }
    
    static func loadFromFile<T: TouchEvent>() -> [T] {
        return []
    }
    
    static func deleteFile() {
        
    }
}

