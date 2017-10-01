//
//  UITableView+Convenience.swift
//  Cart
//
//  Created by Pavlo Muratov on 30.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

extension UITableView {
    func batchUpdates(_ action: () -> ()) {
        beginUpdates()
        action()
        endUpdates()
    }
}
