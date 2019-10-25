//
//  OrderViewController.swift
//  Markets
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, Loadable {
    
    // MARK: - Vars
    private var viewModel: OrderViewModel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        viewModel = OrderViewModel(delegate: self)
        viewModel.fetch()
    }
}

// MARK: - OrderViewModelDelegate
extension OrderViewController: OrderViewModelDelegate {
    func stateDidChange(_ state: APIDataState<Container>) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.hideLoadingView()
            
            switch state {
            case .loaded(let container):
                print(container.price)
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
    func presentError(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}



