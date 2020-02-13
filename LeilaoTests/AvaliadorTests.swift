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
	
	var leiloeiro: Avaliador!
	
	private var joao: Usuario!
	private var jose: Usuario!
	private var maria: Usuario!

    override func setUp() {
		super.setUp()
		leiloeiro = Avaliador()
		
		joao = Usuario(nome: "Joao")
		jose = Usuario(nome: "Jose")
		maria = Usuario(nome: "Maria")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testDeveEntenderLancesEmOrdomCrescente() {
		// Cenario
		let leilao = CriadorDeLeilao().para(descricao: "Playstation 4")
									  .lance(maria, 250.0)
									  .lance(joao, 300.0)
									  .lance(jose, 400.0)
									.constroi()
		
		// Acao
		try? leiloeiro.avalia(leilao: leilao)
		
		// Validacao
		
		XCTAssertEqual(250, leiloeiro.menorLance())
		XCTAssertEqual(400, leiloeiro.maiorLance())
	}

	// Importante: Lembre-se sempre de criar um teste para cada Classe de Equivalência.
	
	func testDeveEntenderLeilaoComApenasUmLance() {
		let leilao = CriadorDeLeilao().para(descricao: "Playstation 4")
		  							  .lance(joao, 1300.0)
									  .constroi()
		
		try? leiloeiro.avalia(leilao: leilao)
		
		XCTAssertEqual(1300.0, leiloeiro.menorLance())
		XCTAssertEqual(1300.0, leiloeiro.maiorLance())
	}
	
	func testDeveEncontrarOsTresMaioresLances() {
		
		let leilao = CriadorDeLeilao().para(descricao: "Playstation 4")
									  .lance(joao, 300.0)
									  .lance(maria, 400.0)
									  .lance(joao, 500.0 )
									  .lance(maria, 600.0)
									  .constroi()
		
		try? leiloeiro.avalia(leilao: leilao)
		
		let listaLances = leiloeiro.tresMaiores()
		
		XCTAssertEqual(3, listaLances.count)
		
		// Sempre que testar uma lista, teste o conteúdo
		XCTAssertEqual(600.0, listaLances[0].valor)
		XCTAssertEqual(500.0, listaLances[1].valor)
		XCTAssertEqual(400.0, listaLances[2].valor)
	}
	
	func testDeveIgnorarLeilaoSemNenhumLance() {
		let leilao = CriadorDeLeilao().para(descricao: "Playstation 4").constroi()
		XCTAssertThrowsError(try leiloeiro.avalia(leilao: leilao), "Não é possível avaliar leilão sem lances") { (error) in
			print(error.localizedDescription)
		}
	}
}
