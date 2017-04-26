//
//  OPIComparisonOPIComparisonPresenterTests.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

import XCTest

class ComparisionPresenterTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    class MockInteractor: ComparisonInteractorInput {

    }

    class MockRouter: ComparisonRouterInput {

    }

    class MockViewController: ComparisonViewInput {

        func setupInitialState() {

        }
    }
}
