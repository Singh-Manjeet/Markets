//
//  LoadingView.swift
//  Markets
//
//  Created by Manjeet Singh on 25/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    public func animate() {
        activityIndicatorView.startAnimating()
    }
}
