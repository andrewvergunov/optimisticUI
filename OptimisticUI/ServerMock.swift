//
//  ServerMock.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/25/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation

class ServerMock {
    let serverDelay = 5
    
    func sendSuccessLike(completion: @escaping ((Bool) -> Void)) {
        let deadlineTime = DispatchTime.now() + .seconds(serverDelay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            completion(true)
        }
    }
    
    func sendFailureLike(completion: @escaping ((Bool) -> Void)) {
        let deadlineTime = DispatchTime.now() + .seconds(serverDelay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            completion(false)
        }
    }
}
