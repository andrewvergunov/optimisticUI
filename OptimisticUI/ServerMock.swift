//
//  ServerMock.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/25/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation

class ServerMock {
    let serverDelay = 2
    typealias CompletionBlock = ((Bool) -> Void)
    
    func sendSuccessLike(completion: @escaping CompletionBlock) {
        handle(success: true, completionBlock: completion)
    }
    
    func sendFailureLike(completion: @escaping CompletionBlock) {
        handle(success: false, completionBlock: completion)
    }
    
    func send(success: Bool, message: String, completion: @escaping CompletionBlock) {
        handle(success: success, completionBlock: completion)
    }
    
    private func handle(success: Bool, completionBlock: @escaping CompletionBlock) {
        let deadlineTime = DispatchTime.now() + .seconds(serverDelay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            completionBlock(success)
        }
    }
}
