//
//  DataBase.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 19/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

//import Foundation
//import CoreData
//import UIKit
//
//class CoreDataPratos {
//    
//    //MARK: - Atributos
//    
//    var contexto:NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
//    var gerenciadorDeResultados:NSFetchedResultsController<EntityPrato>?
//    var prato: EntityPrato?
//    
//    //MARK: - Metodos
//    
//    func recuperaDados() { //DEVE SER CHAMADO NO "viewDidLoad()" OU TODA VEZ QUE ALGUM DADO FOR ALTERADO, SALVO OU APAGADO
//        let pesquisaPrato:NSFetchRequest<EntityPrato> = EntityPrato.fetchRequest()
//        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
//        pesquisaPrato.sortDescriptors = [ordenaPorNome]
//        
//        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaPrato, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do {
//            try gerenciadorDeResultados?.performFetch()
//        } catch {
//            print("ERRO NO: gerenciadorDeResultados?.performFetch()")
//        }
//    }
//    
//    func salvarNovoPrato(nome: String, foto: UIImage, preco: Double, descrissao: String) { //SALVA UMA NOVA INSTANCIA DE "EntityPrato" NO COREDATA A PARTIR DOS PARAMETROS DADOS
//        prato = EntityPrato(context: contexto)
//        
//        prato?.nome = nome
//        prato?.foto = foto
//        prato?.preco = preco
//        prato?.descrissao = descrissao
//        
//        do {
//            try contexto.save()
//            recuperaDados()
//        } catch {
//            print("ERRO AO SALVAR O CONTEXTO")
//        }
//    }
//    
//    func salvarNovoPrato(Prato: Prato) { //SALVA UM NOVO "EntityPrato" NO COREDATA A PARTIR DE UM OBJETO "Prato"
//        prato = EntityPrato(context: contexto)
//        
//        prato?.nome = Prato.nome
//        prato?.foto = Prato.foto
//        prato?.preco = Prato.preco
//        prato?.descrissao = Prato.descrissao
//        
//        
//        do {
//            try contexto.save()
//            recuperaDados()
//        } catch {
//            print("ERRO AO SALVAR O CONTEXTO")
//        }
//    }
//    
//    func apagarPrato(nome: String) {
//        guard let pratos = gerenciadorDeResultados?.fetchedObjects else { print("LISTA DE PRATOS NAO ENCONTRADA"); return }
//        
//        for prato in pratos {
//            if prato.nome == nome {
//                contexto.delete(prato)
//            }
//        }
//        
//        do {
//            try contexto.save()
//            recuperaDados()
//        } catch {
//            print("ERRO AO SALVAR O CONTEXTO")
//        }
//    }
//    
//    func retornaPrato(nome: String) -> Prato? { //PROCURA POR UM "EntityPrato" NO COREDATA A PARTIR DE UM NOME DADO, CASO ENCONTRE O RETORNA COMO UM OBJETO DO TIPO "Prato"
//        
//        guard let pratos = gerenciadorDeResultados?.fetchedObjects else { print("LISTA DE PRATOS NAO ENCONTRADA"); return nil }
//        var pratoEsperado:Prato? = nil
//        
//        for prato in pratos {
//            if prato.nome == nome {
//                guard let nomeEsperado = prato.nome else { print("ERRO"); return nil}
//                guard let fotoEsperada = prato.foto else { print("ERRO"); return nil}
//                let precoEsperado = prato.preco
//                guard let descrissaoEsperada = prato.descrissao else { print("ERRO"); return nil}
//                pratoEsperado = Prato(nome: nomeEsperado, foto: fotoEsperada as! UIImage, preco: precoEsperado, descrissao: descrissaoEsperada)
//            }
//        }
//        
//        if pratoEsperado == nil {
//            print("PRATO NAO ENCONTRADA")
//        }
//        return pratoEsperado
//    }
//    
//    func retornaEntityPrato(nome: String) -> EntityPrato? {//PROCURA POR UM "EntityPrato" NO COREDATA A PARTIR DE UM NOME DADO, CASO ENCONTRE, O RETORNA
//        
//        guard let pratos = gerenciadorDeResultados?.fetchedObjects else { print("LISTA DE PRATOS NAO ENCONTRADA"); return nil }
//        var pratoEsperado:EntityPrato? = nil
//        
//        for prato in pratos {
//            if prato.nome == nome {
//                pratoEsperado = prato
//            }
//        }
//        
//        if pratoEsperado == nil {
//            print("PRATO NAO ENCONTRADA")
//        }
//        return pratoEsperado
//    }
//    
//    func retornaListaDePratos() -> [Prato]? { //PERCORRE TODAS AS "EntityPrato" SALVAS NO COREDATA, PARA CADA UMA, INSTANCIA UMA CLASSE "Prato" E ADICIONA A UMA LISTA, RETORNA ESSA LISTA
//        guard let pratos = gerenciadorDeResultados?.fetchedObjects else { print("LISTA DE PRATOS NAO ENCONTRADA"); return nil }
//        var listaDePratos:Array<Prato> = []
//        
//        for prato in pratos {
//            guard let nomeEsperado = prato.nome else { print("ERRO AO CARREGAR O NOME"); return nil}
//            guard let fotoEsperada = prato.foto else { print("ERRO AO CARREGAR A FOTO"); return nil}
//            let precoEsperado = prato.preco
//            guard let descrissaoEsperada = prato.descrissao else { print("ERRO AO CARREGAR O PRECO"); return nil}
//            listaDePratos.append(Prato(nome: nomeEsperado, foto: fotoEsperada as! UIImage, preco: precoEsperado, descrissao: descrissaoEsperada))
//        }
//        return listaDePratos
//    }
//    
//    func editarPrato(nomeAntigo: String, nome: String? = nil, foto: UIImage? = nil, preco: Double? = nil, descrissao: String? = nil) { //A FUNCAO RECEBE OS PARAMETROS DO PRATO EM VARIAVEIS OPCIONAIS COMO NULOS POR PADRAO, QUANDO A FUNCAO E CHAMADA DEVEM SER PASSADOS APENAS OS DADOS QUE SERAO ALTERADOS, ENTAO A FUNCAO APAGA O PRATO ANTIGO E SALVA UM NOVO ALTERANDO OS PARAMETROS QUE FORAM PASSADOS E MANTENDO OS VALORES QUE NAO FORAM PASSADOS QUANDO A FUNCAO FOI CHAMADA
//        
//        guard let pratoAntigo = retornaPrato(nome: nomeAntigo) else { print("PRATO ANTIGO NAO ENCONTRADO"); return}
//        
//        var novoNome = pratoAntigo.nome
//        var novaFoto = pratoAntigo.foto
//        var novoPreco = pratoAntigo.preco
//        var novaDescrissao = pratoAntigo.descrissao
//        
//        if nome != nil {
//            novoNome = nome!
//        }
//        
//        if foto != nil {
//            novaFoto = foto!
//        }
//        
//        if preco != nil {
//            novoPreco = preco!
//        }
//        
//        if descrissao != nil {
//            novaDescrissao = descrissao!
//        }
//        
//        pratoAntigo.nome = novoNome
//        pratoAntigo.foto = novaFoto
//        pratoAntigo.preco = novoPreco
//        pratoAntigo.descrissao = novaDescrissao
//        
//        do {
//            try contexto.save()
//            recuperaDados()
//        } catch {
//            print("ERRO AO SALVAR O CONTEXTO")
//        }
//    }
//    
//    func apagarTodosOsPratos() { //APAGA TODOS OS DADOS SALVOS NA ENTITY "EntityAdministrador"
//        guard let pratos = gerenciadorDeResultados?.fetchedObjects else { return }
//        for prato in pratos {
//            contexto.delete(prato)
//        }
//        
//        do {
//            try contexto.save()
//            recuperaDados()
//        } catch {
//            print("ERRO AO SALVAR O CONTEXTO")
//        }
//    }
//}
//
//
