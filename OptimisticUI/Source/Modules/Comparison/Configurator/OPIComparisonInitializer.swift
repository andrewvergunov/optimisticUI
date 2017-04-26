//
//  OPIComparisionOPIComparisonInitializer.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

import UIKit

class ComparisionModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var comparisionViewController: ComparisonViewController!

    override func awakeFromNib() {
        let configurator = ComparisionModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: comparisionViewController)
    }
}
