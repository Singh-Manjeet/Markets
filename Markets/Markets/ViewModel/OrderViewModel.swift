//
//  OrderViewModel.swift
//  Markets
//
//  Created by Manjeet Singh on 25/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

// MARK: - Data State
enum DataState<T, E> {
    case loading
    case loaded(T)
    case error(E)
}

// MARK: - Container
struct Container {
    let price: BitcoinPrice
}

// MARK: - OrderViewModelDelegate
protocol OrderViewModelDelegate: class {
    func stateDidChange(_ state: APIDataState<Container>)
}

typealias APIDataState<T> = DataState<T, APIError>

// MARK: - OrderViewModel
final class OrderViewModel {
    
    // MARK: - Vars
    var lowestBuyPrice: Double?
    var highestSellPrice: Double?
    
    var buyingPrice: Double?
    var sellingPrice: Double?
    var hasBuyPriceIncreased: Bool = false
    var hasSellPriceIncreased: Bool = false
    
    private var price: BitcoinPrice? {
        didSet {
            
            guard let price = price,
                let detail = price.detail else { return }
            buyingPrice = detail.buy
            sellingPrice = detail.sell
            updateBitcoinPriceDetails()
        }
    }
    
    weak var delegate: OrderViewModelDelegate?
    
    private(set) var state: APIDataState<Container> = .loading {
        didSet {
            delegate?.stateDidChange(state)
        }
    }
    
    // MARK: - View LifeCycle
    init(delegate: OrderViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetch() {
        DataManager.shared.getBitcoinPrices { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let bitcoinPrice):
                strongSelf.price = bitcoinPrice
                strongSelf.delegate?.stateDidChange(.loaded(Container(price: bitcoinPrice)))
            case .failure(let error):
                strongSelf.delegate?.stateDidChange(.error(APIError(message: error.message)))
            }
        }
    }
}

// MARK: - Public methods
extension OrderViewModel {
       private func updateBitcoinPriceDetails() {
       
        guard let bitCoinPrice = price,
              let priceDetails = bitCoinPrice.detail,
              let currentBuyPrice = priceDetails.buy,
              let currentSellPrice = priceDetails.sell else {
                return
        }
        
        guard let lastBuyingPrice = lowestBuyPrice,
              let lastSellingPrice = highestSellPrice else {
                
                lowestBuyPrice = priceDetails.buy
                highestSellPrice = priceDetails.sell
                hasBuyPriceIncreased = true
                hasSellPriceIncreased = true
                return
        }
        
        hasBuyPriceIncreased = currentBuyPrice > lastBuyingPrice
        hasSellPriceIncreased = currentSellPrice > lastSellingPrice
    }
}
