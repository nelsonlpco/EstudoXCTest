//
//  GeradorPagamento.swift
//  Leilao
//
//  Created by Nelson Prado on 19/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import Foundation

class GeradorPagamento {
    private var leiloes: LeilaoDao
    private var avaliador: Avaliador
    private var repositorioPagamento: RepositorioPagamento
    private var dataPagamento: Date!
    
    init(_ leilaoDao: LeilaoDao, _ avaliador: Avaliador, _ repositorioPagamento: RepositorioPagamento, _ data: Date) {
        self.leiloes = leilaoDao
        self.avaliador = avaliador
        self.repositorioPagamento = repositorioPagamento
        self.dataPagamento = data
    }
    
    convenience init(_ leilaoDao: LeilaoDao, _ avaliador: Avaliador, _ repositorioPagamento: RepositorioPagamento){
        self.init(leilaoDao, avaliador, repositorioPagamento, Date())
    }
    
    func gera() {
        let leiloesEncerrados = self.leiloes.encerrados()
        
        for leilao in leiloesEncerrados {
            try? avaliador.avalia(leilao: leilao)
            
            let novoPagamento = Pagamento(avaliador.maiorLance(), proximoDiaUtil())
            repositorioPagamento.salva(novoPagamento)
        }
    }
    
    func proximoDiaUtil() -> Date {
        var dataAtual = self.dataPagamento!
        
        while Calendar.current.isDateInWeekend(dataAtual) {
            dataAtual = Calendar.current.date(byAdding: .day, value: 1, to: dataAtual)!
        }
        
        return dataAtual
    }
}
