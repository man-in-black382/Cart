//
//  ProductCounterCell.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

class ProductCounterCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        counterLabel.text = nil
        amountLabel.text = nil
    }
    
    // MARK: - Configuration
    
    func configure(with products: [MultipliableProduct]) {
        let (count, sum) = products.reduce((0, 0.0)) { accumulator, multipliableProduct in
            let count = accumulator.0 + multipliableProduct.multiplier
            let sum = accumulator.1 + multipliableProduct.product.currentPrice * Double(multipliableProduct.multiplier)
            return (count, sum)
        }
        
        let plural = NSLocalizedString("numberOfProducts", comment: "")
        counterLabel.text = "\(count) \(plural) на сумму:"
        
        if let priceFormatted = NumberFormatter.priceFormatter.string(from: NSNumber(value: sum)) {
            amountLabel.text = "\(priceFormatted) грн"
        }
    }
    
}
