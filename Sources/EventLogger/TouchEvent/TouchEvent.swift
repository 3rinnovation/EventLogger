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

    private static func getFileURL(type: TouchType) -> URL {
        let fileName = "touch_events_\(type.rawValue).json"
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }

    public static func loadFromFile(type: TouchType) -> Data? {
        let fileURL = getFileURL(type: type)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }

        do {
            return try Data(contentsOf: fileURL)
        } catch {
            print("파일 읽기 실패: \(error)")
            return nil
        }
    }

    public static func deleteFile(type: TouchType) {
        let fileURL = getFileURL(type: type)

        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                print("파일 삭제 완료: \(fileURL.path)")
            } else {
                print("삭제할 파일이 없습니다.")
            }
        } catch {
            print("파일 삭제 실패: \(error)")
        }
    }
}

