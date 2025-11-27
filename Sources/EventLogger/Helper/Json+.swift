//
//  Json+.swift
//  EventLogger
//
//  Created by 김지민 on 11/27/25.
//

import Foundation

extension JSONDecoder {
    static func iso8601Decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension JSONEncoder {
    static func iso8601Encoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
