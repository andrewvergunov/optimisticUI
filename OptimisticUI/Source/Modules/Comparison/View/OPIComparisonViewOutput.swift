//
//  ComparisonOPIComparisionViewOutput.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

protocol ComparisonViewOutput {

    /**
        @author Andrew Vergunov
        Notify presenter that view is ready
    */

    func viewIsReady()

    func didTappedSuccessOptimisticLike()
    func didTappedFailureOptimisticLike()

    func didTappedSuccessRealisticLike()
    func didTappedFailureRealisticLike()

    func didSendSuccess(message: String)
    func didSendFailure(message: String)
}
