//
//  LoginViewController.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 22/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Atributos
    
    var timer: Timer?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var textFieldSenha: UITextField!
    
    @IBOutlet weak var buttonFazerLogin: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func buttonFazerLogin(_ sender: UIButton) {
        
        if ListaDeRestaurantes == nil {
            return
        }
        
        guard let nome = textFieldNome.text else { return }
        guard let senha = textFieldSenha.text else { return }
        
        textFieldNome.text = ""
        textFieldSenha.text = ""
        
        for restaurante in ListaDeRestaurantes! {
            if restaurante.nome == nome {
                if restaurante.senha == senha {
                    RestauranteLogado = restaurante
                    self.performSegue(withIdentifier: "LoginToPedidos", sender: nil)
                    return
                }
            }
        }
        
        Alerta(controller: self).mostrarMensagem(mensagem: "dados invalidos")
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        ajustesDeLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        RestauranteLogado = nil
        timerAtualizaRestaurantes(intervalo: 2)
    }

    override func viewWillDisappear(_ animated: Bool) {


        desligaTimerRestaurantes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PedidosViewController {
            let view = segue.destination as! PedidosViewController
            view.loginController = self
        }
        
        if segue.destination is RegistrarViewController {
            let view = segue.destination as! RegistrarViewController
            view.loginController = self
        }
    }
    
    //MARK: - Metodos
    
    func timerAtualizaRestaurantes(intervalo: Double) {
        
        atualizaListaDeRestaurantes()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: false)
        
        timer = Timer.scheduledTimer(timeInterval: intervalo, target: self, selector: #selector(atualizaListaDeRestaurantes), userInfo: nil, repeats: true)
    }
    
    func desligaTimerRestaurantes() {
        
        timer?.invalidate()
    }
    
    @objc func atualizaListaDeRestaurantes() {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        print(ListaDeRestaurantes?.count)
    }
    
    func ajustesDeLayout() {
        
        //DEIXANDO O "buttonFazerLogin" ARREDONDADO
        
        buttonFazerLogin.layer.masksToBounds = true
        buttonFazerLogin.layer.cornerRadius = 30
        
        //DEIXANDO O "textFieldNome" ARREDONDADO
        
        textFieldNome.layer.masksToBounds = true
        textFieldNome.layer.cornerRadius = 30
        
        //CONFIGURANDO A LARGURA E A COR DA BORDA DO "textFieldNome"
        
        textFieldNome.layer.borderWidth = 2.5
        textFieldNome.layer.borderColor = UIColor.white.cgColor
        
        //SETANDO A COR DE FUNDO DO "textFieldNome" PARA TRANSPARENTE
        
        textFieldNome.backgroundColor = UIColor.clear
        
        //CONFIGURANDO O TEXTO E A COR DO PLACEHOLDER DO "textFieldNome"
        
        textFieldNome.attributedPlaceholder = NSAttributedString(string: "Nome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //DEIXANDO O "textFieldSenha" ARREDONDADO
        
        textFieldSenha.layer.masksToBounds = true
        textFieldSenha.layer.cornerRadius = 30
        
        //CONFIGURANDO A LARGURA E A COR DA BORDA DO "textFieldNome"
        
        textFieldSenha.layer.borderWidth = 2.5
        textFieldSenha.layer.borderColor = UIColor.white.cgColor
        
        //SETANDO A COR DE FUNDO DO "textFieldNome" PARA TRANSPARENTE
        
        textFieldSenha.backgroundColor = UIColor.clear
        
        //CONFIGURANDO O TEXTO E A COR DO PLACEHOLDER DO "textFieldNome"
        
        textFieldSenha.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        //AS 4 LINHAS ABAIXO DEIXAM A "navigationBar" COMPLETAMENTE TRANSPARENTE
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
}
