//
//  CartBarButtonItem.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

class CartBarButtonItem: UIBarButtonItem {

    // MARK: - Types
    
    enum State {
        case add
        case edit
        case cancel
        case apply
        case idle
        
        var localizedTitle: String {
            switch self {
            case .add: return "Добавить"
            case .edit: return "Редакт."
            case .cancel: return "Отменить"
            case .apply: return "Применить"
            case .idle: return ""
            }
        }
    }
    
    // MARK: - Properties
    
    var state: State = .idle {
        didSet {
            self.title = state.localizedTitle
        }
    }
    
}
