//
//  CriadorDeLeilao.swift
//  Leilao
//
//  Created by Nicolau Atala Pelluzi on 13/02/20.
//  Copyright © 2020 Alura. All rights reserved.//

import UIKit

class CriadorDeLeilao: NSObject {
    
    private var leilao:Leilao!
    
    func para(descricao:String) -> Self {
        leilao = Leilao(descricao: descricao)
        
        return self
    }
    
    func naData(data:Date) -> Self {
        leilao.data = data
        
        return self
    }
    
    func lance(_ usuario:Usuario, _ valor:Double) -> Self {
        leilao.propoe(lance: Lance(usuario, valor))
        
        return self
    }
    
    func constroi() -> Leilao {
        return leilao
    }
}
