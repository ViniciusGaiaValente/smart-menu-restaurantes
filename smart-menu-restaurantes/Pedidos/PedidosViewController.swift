//
//  PedidosViewController.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 27/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class PedidosViewController: UIViewController {
    
    //MARK: - Atributos
    
    var loginController: LoginViewController?
    var timer: Timer?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timerAtualizaPedidos(intervalo: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        desligaTimerPedidos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is EditarPratosViewController {
            let view = segue.destination as! EditarPratosViewController
            view.loginController = loginController
            view.pedidosController = self
        }
    }
    
    //MARK: - Metodos
    
    func timerAtualizaPedidos(intervalo: Double) {
        
        atualizaListaDeRestaurantes()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: false)
        
        timer = Timer.scheduledTimer(timeInterval: intervalo, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: true)
    }
    
    func desligaTimerPedidos() {
        
        timer?.invalidate()
    }
    
    @objc func atualizaListaDeRestaurantes() {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if tableView.isEditing == false {
            tableView.reloadData()
        }
        
        print(RestauranteLogado?.pedidos.count)
    }
}

//EXTENSION: - TableView

extension PedidosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RestauranteLogado?.pedidos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let row = indexPath.row
        
        guard let pedido = RestauranteLogado?.pedidos[row] else { return cell}
        
        var textLabel = "Mesa: \(pedido.mesa), Pratos: "
        
        for prato in pedido.pratos {
            
            textLabel.append(contentsOf: "\(prato.nome), ")
        }
        
        cell.textLabel?.text = textLabel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(integerLiteral: 150)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let row = indexPath.row
            
            guard let mesa = RestauranteLogado?.pedidos[row].mesa else { return }
            
            API.apagaPedido(mesa: mesa)
        }
    }
}
