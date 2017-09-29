//
//  CartViewControllerStateType.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

protocol CartViewControllerStrategyType {
    func updateUI(_ cartVC: CartViewController)
    func performLeftBarButtonAction(_ cartVC: CartViewController)
    func performRightBarButtonAction(_ cartVC: CartViewController)
}
