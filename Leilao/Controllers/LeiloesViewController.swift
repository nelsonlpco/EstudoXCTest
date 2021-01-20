//
//  LeiloesViewController.swift
//  Leilao
//
//  Created by Nelson Prado on 19/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import UIKit

class LeiloesViewController: UIViewController, UITableViewDataSource {
    var leiloes: [Leilao] = []
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leiloes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! LeilaoTableViewCell
        
        return cell
    }
    
    func addLeilao(_ leilao: Leilao) {
        leiloes.append(leilao)
    }
}
