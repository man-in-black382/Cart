//
//  CartTableManager.swift
//  Cart
//
//  Created by Pavlo Muratov on 29.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

private enum CartTableSection: Int {
    case products = 0
    case counter = 1
    
    static var total: Int {
        return 2
    }
}

class CartTableManager: NSObject {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private(set) var products = [Product]()
    
    // MARK: - Public interface
    
    func addProduct(_ product: Product) {
        products.append(product)
        let path = IndexPath(row: products.count - 1, section: CartTableSection.products.rawValue)
        tableView.insertRows(at: [path], with: .fade)
    }
    
    func removeProduct(at index: Int) {
        products.remove(at: index)
        let path = IndexPath(row: index, section: CartTableSection.products.rawValue)
        tableView.deleteRows(at: [path], with: .fade)
    }
}

// MARK: - Data Source
extension CartTableManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1// products.isEmpty ? 1 : CartTableSection.total
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = CartTableSection(rawValue: section) else { return 0 }
        switch section {
        case .products: return products.count
        case .counter: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = CartTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .products:
            let productCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self)) as? ProductCell
            productCell?.configure(with: products[indexPath.row])
            return productCell ?? UITableViewCell()
        case .counter:
            return UITableViewCell()
        }
    }
}

// MARK: - Delegate
extension CartTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = CartTableSection(rawValue: indexPath.section) else { return false }
        switch section {
        case .products: return true
        default: return false
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let section = CartTableSection(rawValue: indexPath.section) else { return .none }
        switch section {
        case .products: return .delete
        case .counter: return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        removeProduct(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
