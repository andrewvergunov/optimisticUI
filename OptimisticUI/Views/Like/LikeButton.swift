//
//  LikeButton.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class LikeButton: UIView {
    var isLiked: Bool = false
    let likeAnimationView: LOTAnimationView
    private let startingAnimationProgress: CGFloat = 0.25
    private let unlikeAnimztionProgress: CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        self.likeAnimationView = LikeButton.likeAnimation()
        super.init(coder: aDecoder)
        self.addSubview(self.likeAnimationView)
    }

    private class func likeAnimation() -> LOTAnimationView {
        return LOTAnimationView(name: "TwitterHeart")!
    }

    override init(frame: CGRect) {
        self.likeAnimationView = LikeButton.likeAnimation()
        super.init(frame: frame)

        self.addSubview(self.likeAnimationView)
    }

    func set(liked: Bool) {
        if liked {
            setLike()
        } else {
            unsetLike()
        }
    }

    private func setLike() {
        self.isLiked = true
        self.likeAnimationView.animationProgress = startingAnimationProgress
        self.likeAnimationView.play()
    }

    private func unsetLike() {
        self.isLiked = false
        self.likeAnimationView.animationProgress = unlikeAnimztionProgress
    }
}
