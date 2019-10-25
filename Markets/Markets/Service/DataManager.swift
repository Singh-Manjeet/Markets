//
//  DataManager.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import Alamofire

typealias completionBlock = (Result<BitcoinGBP, APIError>) -> Void
class DataManager {

    // MARK: - Singleton
    static let shared = DataManager()
    private var price: BitcoinGBP?
    
    /* To get the Bitcoin Prices
       It communicates the result using a completion block
    */
    func getBitcoinPrices(onCompletion :@escaping completionBlock) {
       
        guard isConnectedToInternet(),
              let url = URL(string: Constants.Service.getBitcoinPrices) else {
                onCompletion(.failure(APIError()))
                return
        }
        
        AF.request(url)
            .responseDecodable(queue: .global(qos: .background)) { (response: (DataResponse<BitcoinGBP, AFError>)) in

                switch response.result {
                case .success(let price):
                   onCompletion(.success(price))
                case .failure(let error):
                    onCompletion(.failure(APIError(message: error.localizedDescription)))
                }
        }
    }
}

private extension DataManager {
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
