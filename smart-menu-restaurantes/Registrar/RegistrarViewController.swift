//
//  RegistrarViewController.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 23/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class RegistrarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: - Atributos
    
    var loginController: LoginViewController?
    var timer: Timer?
    var imagePicker = UIImagePickerController()
    var isFotoEdited = false
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var textFieldSenha: UITextField!
    
    @IBOutlet weak var imageFoto: UIImageView!
    
    @IBOutlet weak var buttonRegistrar: UIButton!
    
    //MARK: - IBActions
    
    
    @IBAction func buttonRegistrar(_ sender: UIButton) {
        
        guard let nome = textFieldNome.text else { return }
        guard let senha = textFieldSenha.text else { return }
        guard let fotoData = imageFoto.image?.pngData() else { return }
        
        if nome.count < 4 || senha.count < 4 {
            
            Alerta(controller: self).mostrarMensagem(mensagem: "o nome e a senha precisam ter pelo menos 4 caracteres")
            return
        }
        
        for restaurante in ListaDeRestaurantes ?? [] {
            
            if restaurante.nome == nome {
                
                Alerta(controller: self).mostrarMensagem(mensagem: "este nome ja esta em uso")
                return
            }
        }
        
        textFieldSenha.text = ""
        
        do {
            let data = try JSONEncoder().encode(Restaurante(nome: nome, senha: senha, fotoData: fotoData))
            API.salvaRestauranteNoServidor(parametros: data)
            navigationController?.popViewController(animated: true)
            
        } catch {
            print(error)
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        ajustesDeLayout()
        
        let addFotoRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFoto))
        imageFoto.addGestureRecognizer(addFotoRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timerAtualizaRestaurantes(intervalo: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        desligaTimerRestaurantes()
    }
    
    //MARK: - Metodos
    
    //SUBMARK: - Timer
    
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
    
    //SUBMARK: - Camera
    
    @objc func addFoto(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            
            Alerta(controller: self).mostrarMenuDeDuasOpcoes(opcao1Nome: "Tirar Foto", opcao2Nome: "Abrir Galeria", opcao1Acao: tirarFoto, opcao2Acao: escolherFoto)
        }
    }
    
    func tirarFoto(action: UIAlertAction) { //use para abrir a camera para o usuario escolher uma foto
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func escolherFoto(action: UIAlertAction) { //use para abrir a galeria para o usuario escolher uma foto
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            return
        }
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //escreva aqui todo o codigo a ser executado quando o usuario selecionar a foto
        
        var fotoSelecionada: UIImage?
        
        if let fotoEditada = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage) {
            
            if picker.sourceType == .photoLibrary {
                fotoSelecionada = fotoEditada
            } else if picker.sourceType == .camera {
                fotoSelecionada = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
            }
            
        } else if let fotoOriginal = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            
            fotoSelecionada = fotoOriginal
            
        }
        
        imageFoto.image = fotoSelecionada
        imageFoto.backgroundColor = view.backgroundColor
        isFotoEdited = true
        
        imagePicker.dismiss(animated: true)
    }
    
    //SUBMARK: - Layout
    
    func ajustesDeLayout() {
        
        buttonRegistrar.layer.masksToBounds = true
        buttonRegistrar.layer.cornerRadius = 30
        
        textFieldNome.layer.masksToBounds = true
        textFieldNome.layer.cornerRadius = 30
        textFieldNome.layer.borderWidth = 2.5
        textFieldNome.layer.borderColor = UIColor.white.cgColor
        textFieldNome.backgroundColor = UIColor.clear
        textFieldNome.attributedPlaceholder = NSAttributedString(string: "Nome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textFieldSenha.layer.masksToBounds = true
        textFieldSenha.layer.cornerRadius = 30
        textFieldSenha.layer.borderWidth = 2.5
        textFieldSenha.layer.borderColor = UIColor.white.cgColor
        textFieldSenha.backgroundColor = UIColor.clear
        textFieldSenha.attributedPlaceholder = NSAttributedString(string: "Senha", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        //AS 4 LINHAS ABAIXO DEIXAM A "navigationBar" COMPLETAMENTE TRANSPARENTE
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
