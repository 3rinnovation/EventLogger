//
//  KeyboardEvent.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import Foundation

public struct KeyboardEvent: Codable {
    public enum KeyState: String, Codable {
        case pressDown = "PRESS_DOWN"
        case pressUp = "PRESS_UP"
    }

    // 누른 키
    public let key: String
    // 눌렀는지 땠는지
    public let state: KeyState
    // 이벤트 발생 시간 (iso8601)
    public let timestamp: Date
    /// state == "PRESS_UP" 일 경우, holdTime 이 0.5ms 이상일 경우
    public let holodTime: Double?
    /// input field text
    public let inputText: String
    
    private static let fileName = "keyboard_events.log"

    /// 파일 경로 가져오기
    private static func getFileURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
    
    public init(key: String, state: KeyState, timestamp: Date, holodTime: Double?, inputText: String) {
        self.key = key
        self.state = state
        self.timestamp = timestamp
        self.holodTime = holodTime
        self.inputText = inputText
    }
    
    /// 🔹 JSON을 파일에 추가 (읽지 않고 바로 추가)
    static func appendToFile(event: KeyboardEvent) {
        let fileURL = getFileURL()
        
        do {
            let jsonData = try JSONEncoder.iso8601Encoder().encode(event)
            let jsonString = String(data: jsonData, encoding: .utf8)! + "\n"  // 한 줄씩 저장
            
            if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
                fileHandle.seekToEndOfFile() // 파일 끝으로 이동
                fileHandle.write(jsonString.data(using: .utf8)!)
                fileHandle.closeFile()
            } else {
                // 파일이 없으면 새로 생성
                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            }
        } catch {
            print("파일 저장 실패: \(error)")
        }
    }
    
    /// 🔹 저장된 로그 데이터 불러오기
    public static func loadFromFile() -> Data? {
        let fileURL = getFileURL()
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
    
    public static func deleteFile() {
        let fileURL = getFileURL()
        
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
