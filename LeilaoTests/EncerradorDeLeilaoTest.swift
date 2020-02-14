//
//  EncerradorDeLeilaoTest.swift
//  LeilaoTests
//
//  Created by Nicolau Atala Pelluzi on 13/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class EncerradorDeLeilaoTest: XCTestCase {

	var formatador: DateFormatter!
	
    override func setUp() {
		super.setUp()
		formatador = DateFormatter()
		formatador.dateFormat = "yyyy/MM/dd"
    }

    override func tearDown() {
    }
	
	func testDeveEncerrarLeilaoQueComecaramUmaSemanaAntes() {
		
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
		
		let leiloesAntigos = [tvLed, geladeira]
		
		let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()

		stub(daoFalso) { (daoFalso) in
			when(daoFalso.correntes()).thenReturn(leiloesAntigos)
		}
		
		let encerradorDeLeilao = EncerradorDeLeilao(daoFalso)
		encerradorDeLeilao.encerra()
		
		guard let statusTvLed = tvLed.isEncerrado() else { return }
		guard let statusGeladeira = geladeira.isEncerrado() else { return }
		
		XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados())
		XCTAssertTrue(statusTvLed)
		XCTAssertTrue(statusGeladeira)
	}
	
	func testDeveAtualizarLeiloesEncerrados() {
		guard let dataAntiga = formatador.date(from: "2020/01/20") else { return }
		
		let tvLed = CriadorDeLeilao()
						.para(descricao: "TV Led")
						.naData(data: dataAntiga)
						.constroi()
		
		let daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
		
		stub(daoFalso) { (daoFalso) in
			when(daoFalso.correntes()).thenReturn([tvLed])
		}
		
		let encerradorDeLeilao = EncerradorDeLeilao(daoFalso)
		encerradorDeLeilao.encerra()
		
		verify(daoFalso).atualiza(leilao: tvLed)
	}

}

extension Leilao: Matchable {
	public var matcher: ParameterMatcher<Leilao> {
		return equal(to: self)
	}
}
