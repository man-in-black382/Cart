//
//  CATransaction+Convenience.swift
//  Cart
//
//  Created by Pavlo Muratov on 01.10.2017.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

extension CATransaction {
    static func commitNew(transaction: () -> (), completion: (() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        transaction()
        CATransaction.commit()
    }
}
