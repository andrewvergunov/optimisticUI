//
//  ComparisonOPIComparisionPresenter.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

class ComparisonPresenter: ComparisonModuleInput, ComparisonViewOutput, ComparisonInteractorOutput {

    weak var view: ComparisonViewInput!
    var interactor: ComparisonInteractorInput!
    var router: ComparisonRouterInput!

    func viewIsReady() {

    }
}
