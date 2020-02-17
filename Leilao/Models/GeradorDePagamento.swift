//
//  GeradorDePagamento.swift
//  Leilao
//
//  Created by Nicolau Atala Pelluzi on 14/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import Foundation

class GeradorDePagamento {
	private var leiloes: LeilaoDao
	private var avaliador: Avaliador
	private var repositorioDePagamento: RepositorioDePagamento
	private var date: Date
	
	init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorioDePagamento: RepositorioDePagamento, _ data: Date) {
		self.leiloes = leiloes
		self.avaliador = avaliador
		self.repositorioDePagamento = repositorioDePagamento
		self.date = data
	}
	
	convenience init(_ leiloes: LeilaoDao, _ avaliador: Avaliador, _ repositorioDePagamento: RepositorioDePagamento) {
		self.init(leiloes, avaliador, repositorioDePagamento, Date())
	}
	
	func gera() {
		let leiloesEncerrador = self.leiloes.encerrados()
		
		for leilao in leiloesEncerrador {
			try? avaliador.avalia(leilao: leilao)
			
			let novoPagamento = Pagamento(avaliador.maiorLance(), date)
			repositorioDePagamento.salva(novoPagamento)
		}
	}
	
	func proximoDiaUtil() -> Date {
		var dataAtual = date
		while Calendar.current.isDateInWeekend(dataAtual) {
			dataAtual = Calendar.current.date(byAdding: .day, value: 1, to: dataAtual)!
		}
		return dataAtual
	}
}
