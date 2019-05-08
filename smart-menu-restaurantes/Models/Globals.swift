//
//  Globals.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 23/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import Foundation

//MARK: - Atributos

var RestauranteLogado: Restaurante?
var ListaDeRestaurantes:  Array<Restaurante>?

//MARK: - Metodos

func recuperaListaGeralDeRestaurantesDoServidor() {

    func completionAPIRestaurantes(listaDeRestaurantes:  Array<Restaurante>) {
        ListaDeRestaurantes = listaDeRestaurantes
        
        if RestauranteLogado != nil {
            
            for restaurante in ListaDeRestaurantes ?? [] {
                if restaurante.id == RestauranteLogado!.id {
                    RestauranteLogado = restaurante
                }
            }
        }
    }

    API.recuperaRestaurantes(completion: completionAPIRestaurantes)
}
