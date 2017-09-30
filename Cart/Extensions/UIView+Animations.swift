//
//  UIView+Animations.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 0.2, enableInteractions: Bool = true, completion: (() -> ())? = nil) {
        self.isHidden = !enableInteractions
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.alpha = 1.0
        }) { (completed) in
            if let completion = completion {
                completion()
            }
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.2, enableInteractions: Bool = false, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.alpha = 0.0
        }) { (completed) in
            if completed {
                self.isHidden = !enableInteractions
            }
            if let completion = completion {
                completion()
            }
        }
    }
}
