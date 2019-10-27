//
//  DoubleExtension.swift
//  Markets
//
//  Created by Manjeet Singh on 28/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
