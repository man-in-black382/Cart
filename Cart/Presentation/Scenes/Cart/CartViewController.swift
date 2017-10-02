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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet { registerReusableViews() }
    }
    
    @IBOutlet weak var leftBarButton: CartBarButtonItem!
    @IBOutlet weak var rightBarButton: CartBarButtonItem!
    @IBOutlet weak var emptyCartView: UIView!
    
    @IBOutlet var dataManager: CartTableDataManager!
    
    // MARK: - Properties
    
    var state: CartViewControllerState = CartViewControllerBrowsingState()
    let productPool = ProductPool()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        state.enter(self)
        dataManager.delegate = self
    }
    
}

// MARK: - Actions
extension CartViewController {
    @IBAction private func leftBarButtonPressed(_ sender: CartBarButtonItem) {
        state.performLeftBarButtonAction(self)
    }
    
    @IBAction private func rightBarButtonPressed(_ sender: CartBarButtonItem) {
        state.performRightBarButtonAction(self)
    }
}

// MARK: - UI
extension CartViewController {
    private func setupUI() {
        tableView.tableFooterView = UIView()
        tableView.estimatedSectionHeaderHeight = 100
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        view.bringSubview(toFront: emptyCartView)
    }
    
    private func registerReusableViews() {
        let nib = UINib(nibName: String(describing: ProductCounterHeader.self), bundle: Bundle.main)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: ProductCounterHeader.self))
    }
}

// MARK: - CartTableManagerDelegate
extension CartViewController: CartDataManagerDelegate {
    func cartDataManager(_ manager: CartTableDataManager, didRemove product: Product, at index: Int) {
        productPool.putProductBack(product)
        if manager.multipliableProducts.isEmpty {
            emptyCartView.fadeIn()
        }
        state = CartViewControllerBrowsingState()
        state.enter(self)
    }
}
