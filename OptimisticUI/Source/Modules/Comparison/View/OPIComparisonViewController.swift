//
//  ComparisionOPIComparisonViewController.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

import UIKit

class ComparisonViewController: UIViewController, OptimisticMessageDelegate, ComparisonViewInput {
    @IBOutlet weak var realisticMessage: RealisticMessage!
    @IBOutlet weak var optimisticMessage: OptimisticMessage!
    @IBOutlet weak var successOptimisticLike: OptimisticLikeButton!
    @IBOutlet weak var successRealisticLike: RealisticLikeButton!
    @IBOutlet weak var failureOptimisticLike: OptimisticLikeButton!
    @IBOutlet weak var failureRealisticLike: RealisticLikeButton!
    @IBOutlet weak var failureOptimisticMessage: OptimisticMessage!
    @IBOutlet weak var failureRealisticMessage: RealisticMessage!

    private let errorMessage = "Error occured"
    private let message = "Hello world"

    var output: ComparisonViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }

    // MARK: ComparisionViewInput
    func setupInitialState() {
        configureLikeButtons()
        self.failureOptimisticMessage.delegate = self
    }

    private func configureLikeButtons() {
        self.successOptimisticLike.addGestureRecognizer(optimisticLikeRecognizer())
        self.successRealisticLike.addGestureRecognizer(realisticLikeRecognizer())
        self.failureRealisticLike.addGestureRecognizer(realisticLikeRecognizer())
        self.failureOptimisticLike.addGestureRecognizer(optimisticLikeRecognizer())
    }

    private func optimisticLikeRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedOptimisticLike(recognizer:)))
    }

    private func realisticLikeRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(didTappedRealisticLike(recognizer:)))
    }

    @objc private func didTappedOptimisticLike(recognizer: UITapGestureRecognizer) {
        guard let optimisticLike = recognizer.view as? OptimisticLikeButton else {
            return
        }

        if optimisticLike == self.successOptimisticLike {
            output.didTappedSuccessOptimisticLike()
        } else {
            output.didTappedFailureOptimisticLike()
        }
    }

    @objc private func didTappedRealisticLike(recognizer: UITapGestureRecognizer) {
        guard let realisticLike = recognizer.view as? RealisticLikeButton else {
            return
        }

        if realisticLike == self.successRealisticLike {
            output.didTappedSuccessRealisticLike()
        } else {
            output.didTappedFailureRealisticLike()
        }
    }

    @IBAction func sendMessageAction(_ sender: Any) {
        output.didSendSuccess(message: self.message)
    }

    @IBAction func sendFailureMessage(_ sender: Any) {
        output.didSendFailure(message: self.message)
    }

    private func showOptimistic(success: Bool, message: String) {
        let optimisticMessage: OptimisticMessage

        if success {
            optimisticMessage = self.optimisticMessage
        } else {
            optimisticMessage = self.failureOptimisticMessage
        }

        optimisticMessage.hideError()
        optimisticMessage.hideDown()
        optimisticMessage.show(message: message)
        optimisticMessage.startProgress()

        let server = ServerMock()

        server.send(success: success, message: message) { (wasSent) in
            optimisticMessage.stopProgress()

            if !wasSent {
                optimisticMessage.showError(errorMessage: self.errorMessage)
            }
        }
    }

    private func showRealistic(success: Bool, message: String) {
        let realisticMessage: RealisticMessage

        if success {
            realisticMessage = self.realisticMessage
        } else {
            realisticMessage = self.failureRealisticMessage
        }

        realisticMessage.hideDown()
        realisticMessage.startProgress()

        let server = ServerMock()

        server.send(success: success, message: message) { (wasSent) in
            realisticMessage.stopProgress()

            if wasSent {
                realisticMessage.show(message: message)
            } else {
                self.showSending(message: realisticMessage, error: self.errorMessage)
            }
        }
    }

    private func showSending(message: Message, error: String) {
        let alert = UIAlertController(title: error, message: "Message wasn't sent", preferredStyle: .actionSheet)
        let cancellAction = UIAlertAction(title: "Okay", style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
            message.hideError()
        }

        let resendAction = UIAlertAction(title: "Resend message", style: .default) { (_) in
            if message.classForCoder == RealisticMessage.classForCoder() {
                self.showRealistic(success: false, message: "Hello")
            } else {
                self.showOptimistic(success: false, message: "Hello world")
            }
        }

        alert.addAction(cancellAction)
        alert.addAction(resendAction)

        self.present(alert, animated: true, completion: nil)
    }

    func didTappedError(atMessage message: OptimisticMessage) {
        self.showSending(message: message, error: self.errorMessage)
    }
}
