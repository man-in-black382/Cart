//
//  Product.swift
//  Cart
//
//  Created by Pavlo Muratov on 28.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

struct Product: Codable {
    let id: String
    let title: String
    let currentPrice: String
    let oldPrice: String?
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case currentPrice = "price"
        case oldPrice = "old_price"
        case imageURL = "image"
    }
}


