//
//  Pagamento.swift
//  Leilao
//
//  Created by Nicolau Atala Pelluzi on 14/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import Foundation

class Pagamento {
	private var valor: Double
	private var data: Date
	
	init(_ valor: Double, _ data: Date) {
		self.data = data
		self.valor = valor
	}
	
	func getValor() -> Double {
		return valor
	}
	
	func getData() -> Date {
		return data
	}
}
