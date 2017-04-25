//
//  RealisticMessage.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation
import UIKit

class RealisticMessage: Message {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageTopSpace: NSLayoutConstraint!

    override func layoutSubviews() {
        self.messageTopSpace.constant = self.bounds.height
    }
    
    override func show(message: String) {
        self.messageTopSpace.constant = 0
        UIView.animate(withDuration: messageAppearingDuration, animations: {
            self.layoutIfNeeded()
        })
    }
    
    override func hideDown() {
        self.messageTopSpace.constant = self.bounds.height
        self.layoutIfNeeded()
    }

    override func startProgress() {
        self.indicator.startAnimating()
    }
    
    override func stopProgress() {
        self.indicator.stopAnimating()
    }
    
    override func showError(errorMessage: String) {
        
    }
    
}
