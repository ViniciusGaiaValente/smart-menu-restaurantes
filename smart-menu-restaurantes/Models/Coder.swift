//
//  Codificador.swift
//  Smart Menu
//
//  Created by Vinicius Valente on 21/03/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class Coder: NSObject {
    
    static func returnStringData(Of image: UIImage) -> String? {
        
        let imageDataString = image.pngData()?.base64EncodedString()
        return imageDataString
    }
    
    static func returnImage(OfBase64Encoded stringData: String) -> UIImage? {
        
        guard let data = Data(base64Encoded: stringData) else { print("erro na decodificacao da imagem"); return nil}
        
        return UIImage(data: data)
    }
}
