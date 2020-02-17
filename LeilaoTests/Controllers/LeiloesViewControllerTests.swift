//
//  LeiloesViewControllerTests.swift
//  LeilaoTests
//
//  Created by Nicolau Atala Pelluzi on 17/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class LeiloesViewControllerTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
	
	@available(iOS 13.0, *)
	func testTableViewNaoDeveEstarVaziaAposViewDidLoad() {
		let sut = UIStoryboard(name: "Main", bundle: nil)
					.instantiateViewController(identifier: "home") as! LeiloesViewController
		_ = sut.view
		
		XCTAssertNotNil(sut.tableView)
		
	}

}
