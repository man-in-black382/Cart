//
//  CartViewControllerBrowsingStrategy.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

class CartViewControllerBrowsingState: CartViewControllerState {
    
    func enter(_ cartVC: CartViewController) {
        cartVC.leftBarButton.state = .add
        cartVC.rightBarButton.state = .edit
        cartVC.tableManager.isInEditingMode = false
    }
    
    func performLeftBarButtonAction(_ cartVC: CartViewController) {
        if let product = cartVC.productPool.withdrawRandomProduct() {
            cartVC.tableManager.addProduct(product)
            cartVC.emptyCartView.fadeOut()
        } else {
            AlertFacade.showEmptyProductPoolAlert(on: cartVC)
        }
    }
    
    func performRightBarButtonAction(_ cartVC: CartViewController) {
        guard !cartVC.tableManager.multipliableProducts.isEmpty else { return }
        
        cartVC.state = CartViewControllerEditingState()
        cartVC.state.enter(cartVC)
    }
    
}
