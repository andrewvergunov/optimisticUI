//
//  OPIComparisionOPIComparisonConfiguratorTests.swift
//  OptimisticInterface
//
//  Created by Andrew Vergunov on 26/04/2017.
//  Copyright © 2017 NIX. All rights reserved.
//

import XCTest

class ComparisonModuleConfiguratorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigureModuleForViewController() {

        //given
        let viewController = ComparisonViewControllerMock()
        let configurator = ComparisonModuleConfigurator()

        //when
        configurator.configureModuleForViewInput(viewInput: viewController)

        //then
        XCTAssertNotNil(viewController.output, "ComparisonViewController is nil after configuration")
        XCTAssertTrue(viewController.output is ComparisonPresenter, "output is not ComparisionPresenter")

        let presenter: ComparisionPresenter = viewController.output as? ComparisonPresenter
        XCTAssertNotNil(presenter?.view, "view in ComparisonPresenter is nil after configuration")
        XCTAssertNotNil(presenter?.router, "router in ComparisonPresenter is nil after configuration")
        XCTAssertTrue(presenter?.router is ComparisonRouter, "router is not ComparisonRouter")

        let interactor: ComparisonInteractor = presenter.interactor as? ComparisonInteractor
        XCTAssertNotNil(interactor?.output, "output in ComparisonInteractor is nil after configuration")
    }

    class ComparisonViewControllerMock: ComparisonViewController {

        var setupInitialStateDidCall = false

        override func setupInitialState() {
            setupInitialStateDidCall = true
        }
    }
}
