//
//  GeradorDePagamentoTests.swift
//  LeilaoTests
//
//  Created by Nicolau Atala Pelluzi on 14/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class GeradorDePagamentoTests: XCTestCase {
	
	var daoFalso: MockLeilaoDao!
	var avaliadorFalso: Avaliador!
	var pagamentos: MockRepositorioDePagamento!

    override func setUp() {
		daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
		avaliadorFalso = Avaliador()
		pagamentos = MockRepositorioDePagamento().withEnabledSuperclassSpy()
		
    }

    override func tearDown() {
    }

	func testDeveGerarPagamentoParaUmPagamentoEncerrado() {
		let playStation = CriadorDeLeilao().para(descricao: "Playstation")
			.lance(Usuario(nome: "José"), 2000.0)
			.lance(Usuario(nome: "Maria"), 2500.0)
			.constroi()
		
		stub(daoFalso) { (daoFalso) in
			when(daoFalso.encerrados()).thenReturn([playStation])
		}
	
		let geradorDePagamento = GeradorDePagamento(daoFalso, avaliadorFalso, pagamentos)
		geradorDePagamento.gera()
		
		let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
		verify(pagamentos).salva(capturadorDeArgumento.capture())
		
		let pagamentoGerado = capturadorDeArgumento.value
		
		XCTAssertEqual(2500.0, pagamentoGerado?.getValor())
		
	}
	
	func testDeveEmpurrarParaProximoDiaUtil() {
		let playStation = CriadorDeLeilao().para(descricao: "Playstation")
			.lance(Usuario(nome: "José"), 2000.0)
			.lance(Usuario(nome: "Maria"), 2100.0)
			.constroi()
		
		stub(daoFalso) { (daoFalso) in
			when(daoFalso.encerrados()).thenReturn([playStation])
		}
		
		let formatador = DateFormatter()
		formatador.dateFormat = "yyy/MM/dd"
		
		guard let dataAntiga = formatador.date(from: "2020/02/10") else { return }
		
		let geradorDePagamento = GeradorDePagamento(daoFalso, avaliadorFalso, pagamentos, dataAntiga)
		geradorDePagamento.gera()
		
		let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
		verify(pagamentos).salva(capturadorDeArgumento.capture())
		
		let pagamentoGerado = capturadorDeArgumento.value
		
		let formatadorDeData = DateFormatter()
		formatadorDeData.dateFormat = "ccc"
		
		guard let dataDoPagamento = pagamentoGerado?.getData() else { return }
		let diaDaSemana = formatadorDeData.string(from: dataDoPagamento)
		
		XCTAssertEqual("Mon", diaDaSemana)
		
	}
}
