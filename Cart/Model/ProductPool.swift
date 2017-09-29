//
//  ProductPool.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

class ProductPool {
    
    // MARK: - Properties
    
    private var products: [Product]
    
    // MARK: - Lifecycle
    
    init() {
        guard
            let jsonURL = Bundle.main.url(forResource: "products", withExtension: "json"),
            let jsonData = try? Data(contentsOf: jsonURL)
        else {
            self.products = []
            return
        }
        
        let decoder = JSONDecoder()
        let products = try? decoder.decode([Product].self, from: jsonData)
        self.products = products ?? []
    }
    
    // MARK: - Public
    
    func withdrawRandomProduct() -> Product? {
        guard products.count > 0 else { return nil }
        let index = Int(arc4random_uniform(UInt32(products.count)))
        
        defer { products.remove(at: index) }
        return products[index]
    }
    
    func putProductBack(_ product: Product) {
        products.append(product)
    }
    
}
