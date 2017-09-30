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
        cartVC.tableManager.isInEditingMode = true
    }
    
    func performLeftBarButtonAction(_ cartVC: CartViewController) {
        cartVC.state = CartViewControllerBrowsingState()
        cartVC.state.enter(cartVC)
    }
    
    func performRightBarButtonAction(_ cartVC: CartViewController) {
        
    }
    
}
