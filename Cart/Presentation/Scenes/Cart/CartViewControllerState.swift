//
//  CartViewControllerStateType.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation

protocol CartViewControllerState {
    func enter(_ cartVC: CartViewController)
    func performLeftBarButtonAction(_ cartVC: CartViewController)
    func performRightBarButtonAction(_ cartVC: CartViewController)
}
