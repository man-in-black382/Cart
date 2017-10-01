//
//  CartViewControllerEditingStrategy.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

class CartViewControllerEditingState: CartViewControllerState {
    
    func enter(_ cartVC: CartViewController) {
        cartVC.leftBarButton.state = .cancel
        cartVC.rightBarButton.state = .apply
        cartVC.dataManager.toggleEditingModeOn()
    }
    
    func performLeftBarButtonAction(_ cartVC: CartViewController) {
        _ = cartVC.dataManager.discardEditModeChanges()
        cartVC.state = CartViewControllerBrowsingState()
        cartVC.state.enter(cartVC)
    }
    
    func performRightBarButtonAction(_ cartVC: CartViewController) {
        let deletedProducts = cartVC.dataManager.commitEditModeChanges()
        if cartVC.dataManager.multipliableProducts.isEmpty {
            cartVC.emptyCartView.fadeIn()
        }
        cartVC.productPool.putProductsBack(deletedProducts)
        cartVC.state = CartViewControllerBrowsingState()
        cartVC.state.enter(cartVC)
    }
    
}
