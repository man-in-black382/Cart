//
//  CartViewController.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBarButton: CartBarButtonItem!
    @IBOutlet weak var rightBarButton: CartBarButtonItem!
    
    @IBOutlet var tableManager: CartTableManager!
    
    // MARK: - Properties
    
    let productPool = ProductPool()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - Actions
extension CartViewController {
    @IBAction private func leftBarButtonPressed(_ sender: CartBarButtonItem) {
        if let product = productPool.withdrawRandomProduct() {
            tableManager.addProduct(product)
        } else {
            AlertFacade.showEmptyProductPoolAlert(on: self)
        }
    }
    
    @IBAction private func rightBarButtonPressed(_ sender: CartBarButtonItem) {
        
    }
}

// MARK: - UI
extension CartViewController {
    private func setupUI() {
        tableView.tableFooterView = UIView()
    }
}
