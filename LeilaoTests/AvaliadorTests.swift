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

	// Importante: Lembre-se sempre de criar um teste para cada Classe de Equivalência.
	
	func testDeveEntenderLeilaoComApenasUmLance() {
		let joao = Usuario(nome: "Joao")
		let leilao = Leilao(descricao: "Playstation 4")
		leilao.propoe(lance: Lance(joao, 1000.0))
		
		let leiloeiro = Avaliador()
		leiloeiro.avalia(leilao: leilao)
		
		XCTAssertEqual(1000.0, leiloeiro.menorLance())
		XCTAssertEqual(1000.0, leiloeiro.maiorLance())
	}
	
	func testDeveEncontrarOsTresMaioresLances() {
		let joao = Usuario(nome: "Joao")
		let maria = Usuario(nome: "Maria")
		
		let leilao = Leilao(descricao: "Playstation 4")
		leilao.propoe(lance: Lance(joao, 300.0))
		leilao.propoe(lance: Lance(maria, 400.0))
		leilao.propoe(lance: Lance(joao, 500.0))
		leilao.propoe(lance: Lance(maria, 600.0))
		
		let leiloeiro = Avaliador()
		leiloeiro.avalia(leilao: leilao)
		
		let listaLances = leiloeiro.tresMaiores()
		
		XCTAssertEqual(3, listaLances.count)
		
		// Sempre que testar uma lista, teste o conteúdo
		XCTAssertEqual(600.0, listaLances[0].valor)
		XCTAssertEqual(500.0, listaLances[1].valor)
		XCTAssertEqual(400.0, listaLances[2].valor)
	}
}
