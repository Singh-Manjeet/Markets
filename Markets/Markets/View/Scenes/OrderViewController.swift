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
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var sellButton: UIButton!
    @IBOutlet private weak var buyButton: UIButton!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var unitsTextField: UITextField!
    
    private var viewModel: OrderViewModel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = OrderViewModel(delegate: self)
        fetchPricesRepeatedly()
    }
    
    // MARK: - Actions
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        showAlert(with: "This is the only screen, So this button doesnt perform an action, Thanks")
    }
    
    @IBAction func didTapOrderButton(_ sender: UIButton) {
        showAlert(with: "Order Confirmed !!")
    }
    
    @IBAction func didTapSellButton(_ sender: UIButton) {
        sellButton.backgroundColor = UIColor(red: 21.0/255.0,
                                             green: 37.0/255.0,
                                             blue: 57.0/255.0,
                                             alpha: 1.0)
        buyButton.backgroundColor = .brown
    }
    
    @IBAction func didTapBuyButton(_ sender: UIButton) {
        buyButton.backgroundColor = UIColor(red: 21.0/255.0,
                                            green: 37.0/255.0,
                                            blue: 57.0/255.0,
                                            alpha: 1.0)
        sellButton.backgroundColor = .brown
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
                strongSelf.showAlert(with: error.message)
            default:
                break
            }
        }
    }
}

// MARK: - Private Helpers
private extension OrderViewController {
    func setupUI() {
        [buyPriceLabel, sellPriceLabel].forEach { [weak self] label in
            
            guard let strongSelf = self else { return }
            label?.setUpdateBlock { value, label in
                strongSelf.formatPriceLabel(label, value: value)
            }
        }
        
        [cancelButton, orderButton].forEach { button in
            button?.layer.cornerRadius = 10.0
            button?.clipsToBounds = true
        }
        
        orderButton.isEnabled = false
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
        
        formatPriceLabel(lowestBuyPriceLabel, value: CGFloat(viewModel.lowestBuyPrice ?? 0), prefix: "L:")
        formatPriceLabel(highestSellPriceLabel, value: CGFloat(viewModel.highestSellPrice ?? 0), prefix: "H:")
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func formatPriceLabel(_ label: UILabel, value: CGFloat, prefix: String? = nil) {
        let completeText = prefix != nil ? String(format: "%@ %.2f", prefix!, value) : String(format: "%.2f", value)
           let indexOfDecimal = completeText.firstIndex(of: ".")!
           let decimalPartString = completeText.suffix(from: indexOfDecimal)

           let decimalPartRange = (completeText as NSString).range(of: String(decimalPartString))

        let attributedString = NSMutableAttributedString(string: completeText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: prefix != nil ? 20 : 35)])

        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: prefix != nil ? 15 : 30)], range: decimalPartRange)

           label.attributedText = attributedString
       }
}

// MARK: - UITextFieldDelegate
extension OrderViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        switch reason {
        case .committed:
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            updateUI(for: textField)
        default:
            break
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    private func updateUI(for textField: UITextField) {
        if textField == amountTextField {
            
            guard !amountTextField.text!.isEmpty,
                let amount = Double(amountTextField.text!),
                let buyingPrice = viewModel.buyingPrice else {
                    orderButton.isEnabled = false
                    return
            }
            orderButton.isEnabled = true
            let units = amount / buyingPrice
            unitsTextField.text = "\(units.roundTo(places: 2))"
        } else {
            guard !unitsTextField.text!.isEmpty,
                let units = Double(unitsTextField.text!),
                let buyingPrice = viewModel.buyingPrice else {
                    orderButton.isEnabled = false
                    return
            }
            orderButton.isEnabled = true
            let amount = buyingPrice * units
            amountTextField.text = "\(amount.roundTo(places: 2))"
        }
    }
}



