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

	var sut: LeiloesViewController!
	
    override func setUp() {
		if #available(iOS 13.0, *) {
			sut = UIStoryboard(name: "Main", bundle: nil)
				.instantiateViewController(identifier: "home") as? LeiloesViewController
		}
    }

    override func tearDown() {
    }
	
	func testTableViewNaoDeveEstarVaziaAposViewDidLoad() {
		_ = sut.view
		
		XCTAssertNotNil(sut.tableView)
		
	}
	
	func testDataSourceDaTableViewNaoDeveSerNill() {
		_ = sut.view
		XCTAssertNotNil(sut.tableView.dataSource)
		XCTAssertNotNil(sut.tableView.dataSource is LeiloesViewController)
	}
	
	func numberOfRowInSectionsDeveSerAQuantidadeDeLeiloesDaLista() {
		let tableView = UITableView()
		tableView.dataSource = sut
		
		sut.addLeilao(Leilao(descricao: "Playstation 4 "))
		
		XCTAssertEqual(1, tableView.numberOfRows(inSection: 0))
		
		sut.addLeilao(Leilao(descricao: "Nintendo"))
		tableView.reloadData()
		
		XCTAssertEqual(2, tableView.numberOfRows(inSection: 0))
	}

}
