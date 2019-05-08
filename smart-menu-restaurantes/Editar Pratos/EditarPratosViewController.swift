//
//  EditarPratosViewController.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 27/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class EditarPratosViewController: UIViewController {
    
    //MARK: - Atributos
    
    var loginController: LoginViewController?
    var pedidosController : PedidosViewController?
    var timer: Timer?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK - IBActions
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timerAtualizaPratos(intervalo: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        desligaTimerPratos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is AdicionarViewController {
            
            let view = segue.destination as! AdicionarViewController
            
            view.loginController = loginController
            view.editarController = self
        }
    }
    
    //MARK: - Metodos
    
    func timerAtualizaPratos(intervalo: Double) {
        
        atualizaListaDeRestaurantes()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: false)
        
        timer = Timer.scheduledTimer(timeInterval: intervalo, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: true)
    }
    
    func desligaTimerPratos() {
        
        timer?.invalidate()
    }
    
    @objc func atualizaListaDeRestaurantes() {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if tableView.isEditing == false {
            tableView.reloadData()
        }
        
        if RestauranteLogado != nil {
            print(RestauranteLogado!.pratos.count)
        }
    }
}

//EXTENTION: - TableView

extension EditarPratosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RestauranteLogado?.pratos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let row = indexPath.row
        guard let prato = RestauranteLogado?.pratos[row] else { return cell}
        
        cell.textLabel?.text = prato.nome
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let row = indexPath.row
            guard let prato = RestauranteLogado?.pratos[row] else { return }
            
            API.apagaPratoDoCardapio(nome: prato.nome)
            atualizaListaDeRestaurantes()
        }
    }
}
