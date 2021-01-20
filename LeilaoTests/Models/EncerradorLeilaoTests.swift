//
//  EncerradorLeilaoTests.swift
//  LeilaoTests
//
//  Created by Nelson Prado on 18/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

extension Leilao: Matchable {
    public var matcher: ParameterMatcher<Leilao> {
        return equal(to: self)
    }
}

class EncerradorLeilaoTests: XCTestCase {
    var dateFormate: DateFormatter!
    var daoMock: MockLeilaoDao!
    var encerradorDeLeilao: EncerradorDeLeilao!
    var carteiro: MockCarteiro!
    
    override func setUpWithError() throws {
        dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy/MM/dd"
        daoMock = MockLeilaoDao().withEnabledSuperclassSpy()
        carteiro = MockCarteiro().withEnabledSuperclassSpy()
        encerradorDeLeilao = EncerradorDeLeilao(leilaoDAO: daoMock,carteiro: carteiro)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDeveEncerrarLeiloesQueComeceramUmaSemanaAntes() {
        guard let dataAntiga = dateFormate.date(from: "2018/05/09") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let leiloesAntigos = [tvLed, geladeira]
        
        stub(daoMock){ daoMock in
            when(daoMock.correntes()).thenReturn(leiloesAntigos)
        }
        
        encerradorDeLeilao.encerra()
        
        guard let statusTvLed = tvLed.isEncerrado() else {  return }
        guard let statusGeladeira = geladeira.isEncerrado() else {  return }
        
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados())
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
    
    func testDeveAtualizarLeiloesEncerrados() {
        guard let dataAntiga = dateFormate.date(from: "2018/05/19") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        
        stub(daoMock) { (mock) in
            when(mock.correntes()).thenReturn([tvLed])
        }
        
        encerradorDeLeilao.encerra()
        
        verify(daoMock).atualiza(leilao: tvLed)
    }
    
    func testDeveContinarExecucaoMesmoQuandoDaoFalha() {
        guard let dataAntiga = dateFormate.date(from: "2018/05/19") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let error = NSError(domain: "Error", code: 0, userInfo: nil)
        
        stub(daoMock) {
            mock in
            when(mock.correntes()).thenReturn([tvLed,geladeira])
            when(mock.atualiza(leilao: tvLed)).thenThrow(error)
        }
        
        encerradorDeLeilao.encerra()
        
        verify(daoMock).atualiza(leilao: geladeira)
        verify(carteiro).envia(geladeira)
    }

}
