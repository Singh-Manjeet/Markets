//
//  OrderViewController.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import EFCountingLabel

class OrderViewController: UIViewController, Loadable {
    
    // MARK: - Outlets & Vars
    @IBOutlet private weak var buyPriceLabel: EFCountingLabel!
    @IBOutlet private weak var sellPriceLabel: EFCountingLabel!
    @IBOutlet private weak var lowestBuyPriceLabel: UILabel!
    @IBOutlet private weak var highestSellPriceLabel: UILabel!
    @IBOutlet private weak var orderButton: UIButton!
    
    private var viewModel: OrderViewModel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = OrderViewModel(delegate: self)
        fetchPricesRepeatedly()
    }
}

// MARK: - OrderViewModelDelegate
extension OrderViewController: OrderViewModelDelegate {
    func stateDidChange(_ state: APIDataState<Container>) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.hideLoadingView()
            
            switch state {
            case .loaded:
                strongSelf.updateUI()
            case .error(let error):
                strongSelf.presentError(with: error.message)
            default:
                break
            }
        }
    }
}

// MARK: - Private Helpers
private extension OrderViewController {
    func setupUI() {
        [buyPriceLabel, sellPriceLabel].forEach { label in
            label?.setUpdateBlock { value, label in
                label.text = String(format: "%.2f", value)
            }
        }
    }
    
    func fetchPricesRepeatedly() {
        showLoadingView()
        viewModel.fetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.fetchPricesRepeatedly()
        }
    }
    
    func updateUI() {
        buyPriceLabel.countFromCurrentValueTo(CGFloat(viewModel.buyingPrice ?? 0))
        sellPriceLabel.countFromCurrentValueTo(CGFloat(viewModel.sellingPrice ?? 0))
        
        lowestBuyPriceLabel.text = String(format: "L: %.2f", viewModel.lowestBuyPrice ?? 0.00)
        highestSellPriceLabel.text = String(format: "H: %.2f", viewModel.highestSellPrice ?? 0.00)
        buyPriceLabel.textColor = viewModel.hasBuyPriceIncreased ? .green : .red
        sellPriceLabel.textColor = viewModel.hasSellPriceIncreased ? .green : .red
    }
    
    func presentError(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}



