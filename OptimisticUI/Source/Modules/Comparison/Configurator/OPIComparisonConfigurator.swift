//
//  OPIComparisionOPIComparisonConfigurator.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

import UIKit

class ComparisionModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? ComparisonViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: ComparisonViewController) {

        let router = ComparisonRouter()

        let presenter = ComparisonPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ComparisonInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
