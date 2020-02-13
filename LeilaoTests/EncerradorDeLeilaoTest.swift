//
//  EncerradorDeLeilaoTest.swift
//  LeilaoTests
//
//  Created by Nicolau Atala Pelluzi on 13/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class EncerradorDeLeilaoTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
	
	func testDeveEncerrarLeilaoQueComecaramUmaSemanaAntes() {
		let formatador = DateFormatter()
		formatador.dateFormat = "yyyy/MM/dd"
		guard let dataAntiga = formatador.date(from: "2020/01/20") else {
			return
		}
		
		let tvLed = CriadorDeLeilao()
						.para(descricao: "TV Led")
						.naData(data: dataAntiga)
						.constroi()
		
		let geladeira = CriadorDeLeilao()
						.para(descricao: "Geladeira")
						.naData(data: dataAntiga)
						.constroi()
		
		let dao = LeilaoDaoFalse()
		dao.salva(tvLed)
		dao.salva(geladeira)
		
		let encerradorDeLeilao = EncerradorDeLeilao(dao)
		encerradorDeLeilao.encerra()
		
		let leiloesEncerrados = dao.encerrados()
		
		guard let statusTvLed = leiloesEncerrados[0].isEncerrado() else { return }
		guard let statusGeladeira = leiloesEncerrados[1].isEncerrado() else { return }
		
		XCTAssertEqual(2, leiloesEncerrados.count)
		XCTAssertTrue(statusTvLed)
		XCTAssertTrue(statusGeladeira)
	}

}
