//
//  AvaliadorTests.swift
//  LeilaoTests
//
//  Created by Nicolau Atala Pelluzi on 13/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class AvaliadorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testDeveEntenderLancesEmOrdomCrescente() {
		// Cenario
		
		let joao = Usuario(nome: "Joao")
		let jose = Usuario(nome: "Jose")
		let maria = Usuario(nome: "Maria")
		
		let leilao = Leilao(descricao: "Playstation 4")
		leilao.propoe(lance: Lance(maria, 250.0))
		leilao.propoe(lance: Lance(joao, 300.0))
		leilao.propoe(lance: Lance(jose, 400.0))
		
		// Acao
		
		let leiloeiro = Avaliador()
		leiloeiro.avalia(leilao: leilao)
		
		// Validacao
		
		XCTAssertEqual(250, leiloeiro.menorLance())
		XCTAssertEqual(400, leiloeiro.maiorLance())
	}

}
