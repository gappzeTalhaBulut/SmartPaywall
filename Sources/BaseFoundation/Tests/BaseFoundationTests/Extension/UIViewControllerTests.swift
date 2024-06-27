//
//  UIViewControllerTests.swift
//  
//
//  Created by Talip on 10.04.2022.
//

import XCTest
@testable import BaseFoundation

final class UIViewControllerTests: XCTestCase {

    var sut: UIViewController!

    override func setUp() {
        super.setUp()
        sut = UIViewController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_ShouldAddChildViewController() {
        // Given
        let mockViewController = MockViewController()

        // When
        sut.add(mockViewController, to: sut.view)
        _ = sut.view

        // Then
        XCTAssertTrue(sut.children.first is MockViewController)
    }


    // MARK: Stubs
    class MockViewController: UIViewController {}
}
