//
//  BitcoinGBP.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

// MARK: - BitcoinGBP
struct BitcoinGBP: Codable {
    let currency: PriceDetail?
    
    enum CodingKeys: String, CodingKey {
        case currency = "GBP"
    }
}

struct PriceDetail: Codable {
    let fifteenMinDelayed: Double?
    let last: Double?
    let buy: Double?
    let sell: Double?
    let symbol: String?
    
    enum CodingKeys: String, CodingKey {
        case fifteenMinDelayed = "15m"
        case last
        case buy
        case sell
        case symbol
    }
    
}
