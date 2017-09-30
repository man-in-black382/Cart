//
//  MultipliableProduct.swift
//  Cart
//
//  Created by Pavlo Muratov on 30.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

struct MultipliableProduct {
    
    // MARK: - Properties
    
    let product: Product
    var multiplier: Int
    
    // MARK: - Lifecycle
    
    init(product: Product, multiplier: Int = 1) {
        self.product = product
        self.multiplier = multiplier
    }
    
}
