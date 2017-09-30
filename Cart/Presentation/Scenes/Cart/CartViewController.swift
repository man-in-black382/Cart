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
    @IBOutlet weak var emptyCartView: UIView!
    
    @IBOutlet var tableManager: CartDataManager!
    
    // MARK: - Properties
    
    var state: CartViewControllerState = CartViewControllerBrowsingState()
    let productPool = ProductPool()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        state.enter(self)
        tableManager.delegate = self
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
        view.bringSubview(toFront: emptyCartView)
    }
}

// MARK: - CartTableManagerDelegate
extension CartViewController: CartDataManagerDelegate {
    func cartDataManager(_ manager: CartDataManager, willDeleteProductAt index: Int) {
        productPool.putProductBack(manager.multipliableProducts[index].product)
    }
    
    func cartDataManager(_ manager: CartDataManager, didDeleteProductAt index: Int) {
        if manager.multipliableProducts.isEmpty {
            emptyCartView.fadeIn()
        }
    }
    
    func cartDataManager(_ manager: CartDataManager, didAskToDecrementAt index: Int) {
        let newValue = manager.multipliableProducts[index].multiplier - 1
        guard newValue > 0 else { return }
        manager.setMultiplier(newValue, forProductAt: index)
    }
    
    func cartDataManager(_ manager: CartDataManager, didAskToIncrementAt index: Int) {
        manager.setMultiplier(manager.multipliableProducts[index].multiplier + 1, forProductAt: index)
    }
}
