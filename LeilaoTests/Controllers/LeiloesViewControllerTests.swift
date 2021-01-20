//
//  LeiloesViewControllerTests.swift
//  LeilaoTests
//
//  Created by Nelson Prado on 19/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class LeiloesViewControllerTests: XCTestCase {
    var sut: LeiloesViewController!
    
    override func setUpWithError() throws {
        //system under test
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! LeiloesViewController
        _ = sut.view
    }

    override func tearDownWithError() throws {
    }
    
    func testTableViewNaoDeveEStarNilAposViewDidLoad() {
        
        
        XCTAssertNotNil(sut.tableView)
    }
    
    func testDataSourceDataTableViewNaoDeveSerNil() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.dataSource is LeiloesViewController)
    }
    
    func testNumberOfRowsInSectionDeveSerQuantidadeDeLeiloesDaLista() {
        let tableView = UITableView()
        
        sut.addLeilao(Leilao(descricao: "Playstation 4"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.addLeilao(Leilao(descricao: "Iphone X"))
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testCellForRowDeveRetornarLeilaoTableViewCell() {
        let tableView = sut.tableView
        tableView?.dataSource = sut
        
        sut.addLeilao(Leilao(descricao: "TV LEd"))
        
        tableView?.reloadData()
        
        let celula = tableView?.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(celula is LeilaoTableViewCell)
    }
}
