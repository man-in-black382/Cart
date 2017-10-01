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
    @IBOutlet private weak var pcLabel: UILabel!
    @IBOutlet private weak var multiplierView: UIView!
    @IBOutlet private weak var decrementButton: UIButton!
    @IBOutlet private weak var incrementButton: UIButton!
    
    @IBOutlet private weak var multiplierTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    private let oldPriceAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue,
        NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
    ]
    
    var multiplier: Int = 1 {
        didSet {
            pcLabel.text = "\(multiplier) шт."
        }
    }
    
    var incrementAction: ((ProductCell) -> ())?
    var decrementAction: ((ProductCell) -> ())?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearUI()
        
        setupMultiplicationButton(decrementButton)
        setupMultiplicationButton(incrementButton)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearUI()
    }
}

// MARK: - Actions
extension ProductCell {
    @IBAction private func incrementPressed() {
        incrementAction?(self)
    }
    
    @IBAction private func decrementPressed() {
        decrementAction?(self)
    }
}

// MARK: - Private configuration
extension ProductCell {
    private func clearUI() {
        titleLabel.text = nil
        oldPriceLabel.text = nil
        currentPriceLabel.text = nil
        thumbnailImageView.image = nil
        multiplier = 1
    }
    
    private func setupMultiplicationButton(_ button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.tintColor.cgColor
    }
}

// MARK: - Public configuration
extension ProductCell {
    func configure(with multipliableProduct: MultipliableProduct) {
        if let currentPriceFormatted = NumberFormatter.priceFormatter.string(from: NSNumber(value: multipliableProduct.product.currentPrice)) {
            currentPriceLabel.text = "\(currentPriceFormatted) грн"
        }
        
        if let oldPrice = multipliableProduct.product.oldPrice, let oldPriceFormatted = NumberFormatter.priceFormatter.string(from: NSNumber(value: oldPrice)) {
            oldPriceLabel.attributedText = NSAttributedString(string: "\(oldPriceFormatted) грн", attributes: oldPriceAttributes)
            currentPriceLabel.textColor = #colorLiteral(red: 0.9411764706, green: 0.1843137255, blue: 0.1803921569, alpha: 1)
        } else {
            currentPriceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        titleLabel.text = multipliableProduct.product.title
        self.multiplier = multipliableProduct.multiplier
        
        multipliableProduct.product.obtainThumbnail { thumbnail, updatedProduct, isCached in
            DispatchQueue.main.async {
                guard updatedProduct == multipliableProduct.product else { return }
                if !isCached {
                    UIView.transition(with: self.thumbnailImageView, duration: 0.2, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                        self.thumbnailImageView.image = thumbnail
                    })
                } else {
                    self.thumbnailImageView.image = thumbnail
                }
            }
        }
    }
    
    func setMultiplierViewHidden(_ hidden: Bool, animated: Bool) {
        if !animated {
            multiplierView.isHidden = hidden
            multiplierView.alpha = hidden ? 0.0 : 1.0
        } else {
            hidden ? multiplierView.fadeOut() : multiplierView.fadeIn()
        }
    }
}
