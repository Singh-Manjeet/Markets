//
//  OrderViewController.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // temporary calling the api in viewDidLoad
        DataManager.shared.getBitcoinPrices { result in
            
            switch result {
            case .success(let price):
                print(price)

            case .failure(let error):
                print(error.message)
            }
        }
    }
}

