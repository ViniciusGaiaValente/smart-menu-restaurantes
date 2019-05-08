//
//  APIRestaurantes.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 20/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class API: NSObject {

    //MARK: - Inicializadores

    private override init() {
        super.init()
    }

    //MARK: - Meotodos

    static func recuperaRestaurantes(completion: @escaping ([Restaurante]) -> Void) {

        Alamofire.request("http://localhost:3000/restaurantes", method: .get).responseJSON
            { (response) in

                switch response.result {

                case .success(let value):
                    
                    guard let jsonRestaurantes = JSON(value).array else { return }
                    var listaDeRestaurantes: [Restaurante] = []
                    
                    for json in jsonRestaurantes {
                        
                        do {
                            let restaurante = try JSONDecoder().decode(Restaurante.self, from: json.rawData())
                            listaDeRestaurantes.append(restaurante)
                            
                            if listaDeRestaurantes.count > 0 {
                                completion(listaDeRestaurantes)
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                    break

                case .failure(let error):

                    print(error.localizedDescription)

                    break
            }
        }
    }

    static func salvaRestauranteNoServidor(parametros: Data) {

        guard let url = URL(string: "http://localhost:3000/restaurantes") else { print("URL NAO ENCONTRADA"); return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        requisicao.httpBody = parametros
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(requisicao)

    }
    
    static func addPratoNoCardapio(prato: Prato) {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if RestauranteLogado == nil { return }
        
        if RestauranteLogado!.id == nil { return }
        
        RestauranteLogado!.pratos.append(prato)
        
        guard let url = URL(string: "http://localhost:3000/restaurantes/\(RestauranteLogado!.id!)") else { print("URL NAO ENCONTRADA"); return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            requisicao.httpBody = try JSONEncoder().encode(RestauranteLogado!)
            Alamofire.request(requisicao)
        } catch {
            print(error)
        }
    }
    
    static func apagaPratoDoCardapio(nome: String) {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if RestauranteLogado == nil { return }
        
        if RestauranteLogado!.id == nil { return }
        
        var i = 0
        
        for prato in RestauranteLogado!.pratos {
            
            if prato.nome == nome {
                
                RestauranteLogado!.pratos.remove(at: i)
                
                break
            }
            i += 1
        }
        
        guard let url = URL(string: "http://localhost:3000/restaurantes/\(RestauranteLogado!.id!)") else { print("URL NAO ENCONTRADA"); return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            requisicao.httpBody = try JSONEncoder().encode(RestauranteLogado!)
            Alamofire.request(requisicao)
        } catch {
            print(error)
        }
    }
    
    static func addPedido(pedido: Pedido) {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if RestauranteLogado == nil { print("erro1"); return }
        
        if RestauranteLogado!.id == nil { print("erro2"); return }
        
        var i = 0
        
        for pedidoPercorrido in RestauranteLogado!.pedidos{
            
            if pedido.mesa == pedidoPercorrido.mesa {
                
                for prato in pedidoPercorrido.pratos {
                    
                    RestauranteLogado!.pedidos[i].pratos.append(prato)
                }
            } else {
                RestauranteLogado!.pedidos.append(pedido)
            }
            i += 1
        }
        
        if RestauranteLogado!.pedidos.count == 0 {
            RestauranteLogado!.pedidos.append(pedido)
        }
        
        guard let url = URL(string: "http://localhost:3000/restaurantes/\(RestauranteLogado!.id!)") else { print("URL NAO ENCONTRADA"); return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            requisicao.httpBody = try JSONEncoder().encode(RestauranteLogado!)
            Alamofire.request(requisicao)
        } catch {
            print(error)
        }
    }
    
    static func apagaPedido(mesa: String) {
        
        recuperaListaGeralDeRestaurantesDoServidor()
        
        if RestauranteLogado == nil { return }
        
        if RestauranteLogado!.id == nil { return }
        
        var i = 0
        for pedido in RestauranteLogado!.pedidos{
            if pedido.mesa == mesa {
                RestauranteLogado!.pedidos.remove(at: i)
                break
            }
            i += 1
        }
        
        guard let url = URL(string: "http://localhost:3000/restaurantes/\(RestauranteLogado!.id!)") else { print("URL NAO ENCONTRADA"); return }
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            requisicao.httpBody = try JSONEncoder().encode(RestauranteLogado!)
            Alamofire.request(requisicao)
        } catch {
            print(error)
        }
    }
}
