//
//  ViewController.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import UIKit

class ComparisonViewController: UIViewController {
    @IBOutlet weak var realisticMessage: RealisticMessage!
    @IBOutlet weak var optimisticMessage: OptimisticMessage!
    @IBOutlet weak var successOptimisticLike: OptimisticLikeButton!
    @IBOutlet weak var successRealisticLike: RealisticLikeButton!
    @IBOutlet weak var failureOptimisticLike: OptimisticLikeButton!
    @IBOutlet weak var failureRealisticLike: RealisticLikeButton!

    private let errorMessage = "Error occured"
    
    override func viewDidLoad() {
        configureLikeButtons()
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
        let optimisticLike = recognizer.view as! OptimisticLikeButton
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
        let realisticLike = recognizer.view as! RealisticLikeButton
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
        showRealistic(message: message)
        showOptimistic(message: message)
    }
    
    private func showOptimistic(message: String) {
        self.optimisticMessage.hideDown()
        self.optimisticMessage.show(message: message)
        self.optimisticMessage.startProgress()
        
        let server = ServerMock()
        
        server.sendSuccess(message: message) { (wasSent) in
            self.optimisticMessage.stopProgress()

            if !wasSent {
                self.optimisticMessage.show(message: self.errorMessage)
            }
        }
    }
    
    private func showRealistic(message: String) {
        self.realisticMessage.hideDown()
        self.realisticMessage.startProgress()
        
        let server = ServerMock()
        
        server.sendSuccess(message: message) { (wasSent) in
            self.realisticMessage.stopProgress()

            if wasSent {
                self.realisticMessage.show(message: message)
            } else {
                self.realisticMessage.showError(errorMessage: self.errorMessage)
            }
        }
    }
}
