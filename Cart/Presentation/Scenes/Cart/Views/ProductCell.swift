//
//  ProductCell.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var oldPriceLabel: UILabel!
    @IBOutlet private weak var currentPriceLabel: UILabel!
    @IBOutlet private weak var multiplierView: UIView!
    @IBOutlet private weak var decrementButton: UIButton!
    @IBOutlet private weak var incrementButton: UIButton!
    
    // MARK: - Configuration
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        oldPriceLabel.text = product.oldPrice
        currentPriceLabel.text = product.currentPrice
        product.obtainThumbnail { thumbnail, updatedProduct, isCached in
            DispatchQueue.main.async {
                guard updatedProduct == product else { return }
                if !isCached {
                    UIView.transition(with: self.thumbnailImageView, duration: 0.25, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                        self.thumbnailImageView.image = thumbnail
                    })
                } else {
                    self.thumbnailImageView.image = thumbnail
                }
            }
        }
    }

}
