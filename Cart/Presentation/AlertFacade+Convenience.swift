//
//  AlertFacade+Convenience.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

extension AlertFacade {
    static func showEmptyProductPoolAlert(on viewController: UIViewController) {
        AlertFacade.showAlert(title: "Товары закончились", message: "На складе не осталось товаров", on: viewController)
    }
}
