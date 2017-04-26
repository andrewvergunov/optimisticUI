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

    var output: ComparisonViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureLikeButtons()
        self.failureOptimisticMessage.delegate = self
    }

    // MARK: ComparisionViewInput
    func setupInitialState() {
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
        let server = ServerMock()
        guard let optimisticLike = recognizer.view as? OptimisticLikeButton else {
            return
        }

        optimisticLike.set(liked: !optimisticLike.isLiked)

        let completionBlock: ((Bool) -> Void) = { (isSuccess) in
            if !isSuccess {
                optimisticLike.set(liked: !optimisticLike.isLiked)
            }
        }

        if optimisticLike == self.successOptimisticLike {
            server.sendSuccessLike(completion: completionBlock)
        } else {
            server.sendFailureLike(completion: completionBlock)
        }
    }

    @objc private func didTappedRealisticLike(recognizer: UITapGestureRecognizer) {
        let server = ServerMock()
        guard let realisticLike = recognizer.view as? RealisticLikeButton else {
            return
        }

        realisticLike.hideError()
        realisticLike.startProgress()

        let completionBlock: ((Bool) -> Void) = { (isSuccess) in
            realisticLike.stopProgress()

            if isSuccess {
                realisticLike.set(liked: !realisticLike.isLiked)
            } else {
                realisticLike.show(failureMessage: self.errorMessage)
            }
        }

        if realisticLike == self.successRealisticLike {
            server.sendSuccessLike(completion: completionBlock)
        } else {
            server.sendFailureLike(completion: completionBlock)
        }
    }

    @IBAction func sendMessageAction(_ sender: Any) {
        let message = "Hello world!"
        showRealistic(success: true, message: message)
        showOptimistic(success: true, message: message)
    }

    @IBAction func sendFailureMessage(_ sender: Any) {
        let message = "Hello world!"
        showRealistic(success: false, message: message)
        showOptimistic(success: false, message: message)
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
