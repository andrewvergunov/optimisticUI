//
//  OptimisticMessage.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation
import UIKit

class OptimisticMessage: Message {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var messageTopSpace: NSLayoutConstraint!
    @IBOutlet weak var messageTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    
    private let messageTrailingOffset: CGFloat = 40
    
    override func layoutSubviews() {
        self.messageTopSpace.constant = self.bounds.height
    }
    
    override func show(message: String) {
        self.messageTopSpace.constant = 0
        
        UIView.animate(withDuration: messageAppearingDuration) {
            self.layoutIfNeeded()
        }
    }
    
    override func hideDown() {
        self.messageTopSpace.constant = self.bounds.height
        self.layoutIfNeeded()
    }

    override func startProgress() {
        self.messageTrailingSpace.constant = messageTrailingOffset
        self.indicator.startAnimating()
        self.layoutIfNeeded()
    }
    
    override func stopProgress() {
        self.indicator.stopAnimating()
        self.messageTrailingSpace.constant = 0
        self.layoutIfNeeded()
    }

    override func showError(errorMessage: String) {
        
    }
}
