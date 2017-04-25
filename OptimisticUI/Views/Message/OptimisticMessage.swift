//
//  OptimisticMessage.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation
import UIKit

@objc protocol OptimisticMessageDelegate {
    @objc optional func didTappedError(atMessage message: OptimisticMessage)
}

class OptimisticMessage: Message {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var messageTopSpace: NSLayoutConstraint!
    @IBOutlet weak var messageTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    @IBOutlet weak var errorImage: UIImageView!

    var delegate: OptimisticMessageDelegate?

    private let messageTrailingOffset: CGFloat = 40

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureErrorImage()
    }

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
        self.messageTrailingSpace.constant = messageTrailingOffset
        self.layoutIfNeeded()
        self.errorImage.isHidden = false
    }

    override func hideError() {
        self.messageTrailingSpace.constant = 0
        self.layoutIfNeeded()
        self.errorImage.isHidden = true
    }

    private func configureErrorImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(errorTapped(recognizer:)))
        self.errorImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func errorTapped(recognizer: UITapGestureRecognizer) {
        self.delegate?.didTappedError?(atMessage: self)
    }
}
