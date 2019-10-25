//
//  BitcoinPrice.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

// MARK: - BitcoinPrice
struct BitcoinPrice: Codable {
    let detail: Detail?
    
    enum CodingKeys: String, CodingKey {
        case detail = "GBP"
    }
}

struct Detail: Codable {
    let fifteenMinDelayed: Double?
    let last: Double?
    let buy: Double?
    let sell: Double?
    let symbol: String?
    
    enum CodingKeys: String, CodingKey {
        case fifteenMinDelayed = "15m"
        case last = "last"
        case buy = "buy"
        case sell = "sell"
        case symbol = "symbol"
    }
    
}
