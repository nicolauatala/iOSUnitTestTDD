//
//  LeiloesViewController.swift
//  Leilao
//
//  Created by Nicolau Atala Pelluzi on 17/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class LeiloesViewController: UIViewController, UITableViewDataSource {

	// MARK: - IBOutlets
	
	@IBOutlet weak var tableView: UITableView!
	
	private var listaDeLeiloes:[Leilao] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	func addLeilao(_ leilao: Leilao) {
		listaDeLeiloes.append(leilao)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listaDeLeiloes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let celulaLeilao = tableView.dequeueReusableCell(withIdentifier: "LeilaoTablewViewCell", for: indexPath)
		return celulaLeilao
	}
    
}
