//
//  GeradorPagamentoTests.swift
//  LeilaoTests
//
//  Created by Nelson Prado on 19/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
import Cuckoo
@testable import Leilao

class GeradorPagamentoTests: XCTestCase {
    var daoMock: MockLeilaoDao!
    var avaliador: Avaliador!
    var pagamentos: MockRepositorioPagamento!

    override func setUpWithError() throws {
        daoMock = MockLeilaoDao().withEnabledSuperclassSpy()
        avaliador = Avaliador()
        pagamentos = MockRepositorioPagamento().withEnabledSuperclassSpy()
    }

    override func tearDownWithError() throws {
        
    }

    func testDeveGerarPagamentoParaUmLeilaoEncerrado() {
        let ps = CriadorDeLeilao()
            .para(descricao: "Playstation")
            .lance(Usuario(nome: "José"), 2000.0)
            .lance(Usuario(nome: "Maria"), 2500.0)
            .constroi()
        
        stub(daoMock) {
            mock in
            when(mock.encerrados()).thenReturn([ps])
        }
       
        
        let geradorDePagamento = GeradorPagamento(daoMock, avaliador, pagamentos)
        
        geradorDePagamento.gera()

        let argCapture = ArgumentCaptor<Pagamento>()
        
        verify(pagamentos).salva(argCapture.capture())
        
        let pagamentoGerado = argCapture.value

        
        XCTAssertEqual(2500.0, pagamentoGerado?.getValor())
    }
    
    func testDeveEmpurrarParaProximoDiaUtil() {
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy/MM/dd"
        
        guard let dataAntiga = dtf.date(from: "2018/05/2019") else {  return }
        
        
        let iphone = CriadorDeLeilao()
            .para(descricao: "IPhone")
            .lance(Usuario(nome: "João"), 2000.0)
            .lance(Usuario(nome: "Maria"), 2500.0)
            .constroi()
        
        stub(daoMock){
            mock in
            when(mock.encerrados()).thenReturn([iphone])
        }
        
        let geradorDePagamento = GeradorPagamento(daoMock,avaliador, pagamentos, dataAntiga)
        geradorDePagamento.gera()
        
        let argCaptur = ArgumentCaptor<Pagamento>()
        verify(pagamentos).salva(argCaptur.capture())
        
        let pagamentoGerado = argCaptur.value
        
        
        dtf.dateFormat  = "ccc"
        
        guard let dataDoPagamento = pagamentoGerado?.getData() else {  return }
        let diaDaSemana = dtf.string(from: dataDoPagamento)
        
        XCTAssertEqual("Mon", diaDaSemana)
    }

}
