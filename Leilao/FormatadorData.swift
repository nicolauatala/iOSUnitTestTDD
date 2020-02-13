//
//  FormatadorData.swift
//  Leilao
//
//  Created by Nicolau Atala Pelluzi on 13/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import Foundation

class FormatadorData {
    
    class func formataDataParaString(_ data:Date) -> String {
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return formatador.string(from: data)
    }
    
    class func formataStringParaData(_ data:String) -> Date? {
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd HH:mm:ss"
        guard let dataFormatada = formatador.date(from: data) else { return nil }
        
        return dataFormatada
    }
    
}
