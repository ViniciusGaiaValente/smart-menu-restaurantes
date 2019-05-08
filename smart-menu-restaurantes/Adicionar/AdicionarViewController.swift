//
//  AdicionarViewController.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 27/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class AdicionarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Atributos
    
    var loginController: LoginViewController?
    var editarController: EditarPratosViewController?
    let imagePicker = UIImagePickerController()
    var isFotoEdited = false
    var timer: Timer?
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageFoto: UIImageView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    
    @IBOutlet weak var textFieldPreco: UITextField!
    
    @IBOutlet weak var textViewDescrissao: UITextView!
    
    @IBOutlet weak var buttonSalvar: UIButton!
    
    //MARK: - IBActions
    
    @IBAction func buttonSalvar(_ sender: UIButton) {
        
        if RestauranteLogado == nil {
            
            Alerta(controller: self).mostrarMensagem(mensagem: "login expirado")
            navigationController?.popToRootViewController(animated: true)
        }
        
        if isFotoEdited == false {
            
            Alerta(controller: self).mostrarMensagem(mensagem: "foto invalida")
            return
        }
        
        guard let nome = textFieldNome.text else { return }
        guard let preco = Double(textFieldPreco.text!) else { return }
        guard let descrissao = textViewDescrissao.text else { return }
        
        var prato: Prato?
        
        if isFotoEdited == false {
            
            prato = Prato(nome: nome, preco: preco, descrissao: descrissao)
        } else {
            
            guard let fotoData = imageFoto.image?.pngData() else { return }
            
            prato = Prato(nome: nome, fotoData: fotoData, preco: preco, descrissao: descrissao)
        }
        
        for pratoPercorrido in RestauranteLogado!.pratos {
            
            if prato!.nome == pratoPercorrido.nome {
                
                Alerta(controller: self).mostrarMensagem(mensagem: "ja existe um prato com esse nome")
                return
            }
        }
        
        API.addPratoNoCardapio(prato: prato!)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        ajustesDeLayout()
        
        let addFotoRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFoto))
        imageFoto.addGestureRecognizer(addFotoRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timerAtualizaPratos(intervalo: 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        desligaTimerPratos()
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
        
        if RestauranteLogado != nil {
            print(RestauranteLogado!.pratos.count)
        }
    }
    
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
    
    func ajustesDeLayout() {
        
        buttonSalvar.layer.masksToBounds = true
        buttonSalvar.layer.cornerRadius = 30
        
        textFieldNome.layer.masksToBounds = true
        textFieldNome.layer.cornerRadius = 30
        textFieldNome.layer.borderWidth = 2.5
        textFieldNome.layer.borderColor = UIColor.white.cgColor
        textFieldNome.backgroundColor = UIColor.clear
        textFieldNome.attributedPlaceholder = NSAttributedString(string: "Nome", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textFieldPreco.layer.masksToBounds = true
        textFieldPreco.layer.cornerRadius = 30
        textFieldPreco.layer.borderWidth = 2.5
        textFieldPreco.layer.borderColor = UIColor.white.cgColor
        textFieldPreco.backgroundColor = UIColor.clear
        textFieldPreco.attributedPlaceholder = NSAttributedString(string: "Preço", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        textViewDescrissao.layer.masksToBounds = true
        textViewDescrissao.layer.cornerRadius = 30
        textViewDescrissao.layer.borderWidth = 2.5
        textViewDescrissao.layer.borderColor = UIColor.white.cgColor
        textViewDescrissao.backgroundColor = UIColor.clear
        
        //AS 4 LINHAS ABAIXO DEIXAM A "navigationBar" COMPLETAMENTE TRANSPARENTE
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
