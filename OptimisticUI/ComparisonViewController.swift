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

    override func viewDidLoad() {
        confgureMessages()
        configureLikeButtons()
    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        let message = "Hello world!"
        self.optimisticMessage.show(message: message)
        self.realisticMessage.show(message: message)
    }
    
    private func configureLikeButtons() {
        let optimisticLikeRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedOptimisticLike(recognizer:)))
        let realisticLikeRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedRealisticLike(recognizer:)))
        self.successOptimisticLike.addGestureRecognizer(optimisticLikeRecognizer)
        self.successRealisticLike.addGestureRecognizer(realisticLikeRecognizer)
    }
    
    private func confgureMessages() {

    }
    
    @objc private func didTappedOptimisticLike(recognizer: UITapGestureRecognizer) {
        let server = ServerMock()
        let optimisticLike = recognizer.view as! OptimisticLikeButton
        optimisticLike.set(liked: !optimisticLike.isLiked)
        
        server.sendSuccessLike { (isSuccess) in
            if !isSuccess {
                optimisticLike.set(liked: !optimisticLike.isLiked)
            }
        }
    }
    
    @objc private func didTappedRealisticLike(recognizer: UITapGestureRecognizer) {
        let server = ServerMock()
        let realisticLike = recognizer.view as! RealisticLikeButton
        realisticLike.startProgress()
        
        server.sendSuccessLike { (isSuccess) in
            realisticLike.stopProgress()
            
            if isSuccess {
                realisticLike.set(liked: !realisticLike.isLiked)
            }
        }
    }
    
}
