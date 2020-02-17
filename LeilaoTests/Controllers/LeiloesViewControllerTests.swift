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
	var tableView: UITableView!
	
    override func setUp() {
		if #available(iOS 13.0, *) {
			sut = UIStoryboard(name: "Main", bundle: nil)
				.instantiateViewController(identifier: "home") as? LeiloesViewController
		}
		_ = sut.view
		tableView = sut.tableView
		tableView.dataSource = sut
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
	
	func testNumberOfRowInSectionsDeveSerAQuantidadeDeLeiloesDaLista() {
		let tableView = UITableView()
		tableView.dataSource = sut
		
		sut.addLeilao(Leilao(descricao: "Playstation 4 "))
		
		XCTAssertEqual(1, tableView.numberOfRows(inSection: 0))
		
		sut.addLeilao(Leilao(descricao: "Nintendo"))
		tableView.reloadData()
		
		XCTAssertEqual(2, tableView.numberOfRows(inSection: 0))
	}
	
	func testCellForRowDeveRetornarLeilaoTableViewCell() {
		sut.addLeilao(Leilao(descricao: "Playstation 4 "))
		tableView.reloadData()
		
		let celula = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
		
		XCTAssertTrue(celula is LeilaoTableViewCell)
		
	}
	
	func testCellForRowDeveChamarDequeueReusable() {
		let mockTablewView = MockTableView()
		mockTablewView.dataSource = sut
		
		mockTablewView.register(LeilaoTableViewCell.self, forCellReuseIdentifier: "LeilaoTablewViewCell")
		
		sut.addLeilao(Leilao(descricao: "Nintendo"))
		mockTablewView.reloadData()
		
		_ = mockTablewView.cellForRow(at: IndexPath(row: 0, section: 0))
		
		XCTAssertTrue(mockTablewView.celulaForReutilizada)
	}

}

extension LeiloesViewControllerTests {
	class MockTableView: UITableView {
		var celulaForReutilizada = false
		
		override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
			celulaForReutilizada = true
			return super.dequeueReusableCell(withIdentifier: "LeilaoTablewViewCell", for: indexPath)
		}
	}
}
