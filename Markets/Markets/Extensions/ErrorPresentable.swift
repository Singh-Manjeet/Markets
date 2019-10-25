//
//  ErrorPresentable.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

protocol ErrorPresentable {
    var message: String { get }
}

struct APIError: Error, ErrorPresentable {
    let message: String
    let code: Int
    
    init(message: String? = nil, code: Int? = 404) {
        self.message = message ?? "Network Error Occured. Please try again"
        self.code = code ?? 404
    }
}
