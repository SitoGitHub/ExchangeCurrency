//
//  WebSiteModel.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import Foundation

// MARK: структура для парсинга курса валют - https://www.cbr-xml-daily.ru/daily_json.js

struct WebSiteDecodable: Codable {
    let date, previousDate: Date
    let previousURL: String
    let timestamp: Date
    let valute: [String: Valute]
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

// Valute
struct Valute: Codable {
    let id, numCode, charCode: String
    let nominal: Int
    let name: String
    let value, previous: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}
