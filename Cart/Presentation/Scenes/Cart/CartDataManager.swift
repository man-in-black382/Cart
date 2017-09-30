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
    
    var indexSet: IndexSet {
        return IndexSet(integer: rawValue)
    }
    
    static var total: Int {
        return 2
    }
}

protocol CartDataManagerDelegate: class {
    func cartDataManager(_ manager: CartDataManager, willDeleteProductAt index: Int)
    func cartDataManager(_ manager: CartDataManager, didDeleteProductAt index: Int)
    func cartDataManager(_ manager: CartDataManager, didAskToIncrementAt index: Int)
    func cartDataManager(_ manager: CartDataManager, didAskToDecrementAt index: Int)
}

class CartDataManager: NSObject {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: String(describing: ProductCounterHeader.self), bundle: Bundle.main)
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: ProductCounterHeader.self))
        }
    }
    
    // MARK: - Properties
    
    private(set) var multipliableProducts = [MultipliableProduct]()
    
    weak var delegate: CartDataManagerDelegate?
    
    var isInEditingMode = false {
        didSet {
            setCounterSectionHidden(isInEditingMode)
            setMultiplierViewHiddenForAllCells(isInEditingMode)
        }
    }
    
    // MARK: - Public interface
    
    func addProduct(_ product: Product) {
        multipliableProducts.append(MultipliableProduct(product: product))
        let path = IndexPath(row: multipliableProducts.count - 1, section: CartTableSection.products.rawValue)
        tableView.updateSafely {
            tableView.insertRows(at: [path], with: .fade)
            if (multipliableProducts.count == 1) {
                setCounterSectionHidden(false)
            }
        }
    }
    
    func removeProduct(at index: Int) {
        multipliableProducts.remove(at: index)
        let path = IndexPath(row: index, section: CartTableSection.products.rawValue)
        tableView.updateSafely {
            tableView.deleteRows(at: [path], with: .fade)
            if (multipliableProducts.isEmpty) {
                setCounterSectionHidden(true)
            }
        }
    }
    
    func setMultiplier(_ multiplier: Int, forProductAt index: Int) {
        multipliableProducts[index].multiplier = multiplier
        let path = IndexPath(row: index, section: CartTableSection.products.rawValue)
        let cell = tableView.cellForRow(at: path) as? ProductCell
        cell?.multiplier = multiplier
    }
    
    // MARK: - Private helpers
    
    private func setMultiplierViewHiddenForAllCells(_ hidden: Bool) {
        tableView.visibleCells.forEach {
            ($0 as? ProductCell)?.setMultiplierViewHidden(hidden, animated: true)
        }
    }
    
    private func setCounterSectionHidden(_ hidden: Bool) {
        tableView.updateSafely {
            if hidden && tableView.numberOfSections == CartTableSection.total {
                tableView.deleteSections(CartTableSection.counter.indexSet, with: .fade)
            } else if !hidden && tableView.numberOfSections == 1{
                tableView.insertSections(CartTableSection.counter.indexSet, with: .fade)
            }
        }
    }
    
    private func productCell(at index: Int) -> ProductCell? {
        let productCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self)) as? ProductCell
        productCell?.configure(with: multipliableProducts[index])
        productCell?.decrementAction = { [weak self] cell in
            guard let strongSelf = self, let row = strongSelf.tableView.indexPath(for: cell)?.row else { return }
            strongSelf.delegate?.cartDataManager(strongSelf, didAskToDecrementAt: row)
        }
        productCell?.incrementAction = { [weak self] cell in
            guard let strongSelf = self, let row = strongSelf.tableView.indexPath(for: cell)?.row else { return }
            strongSelf.delegate?.cartDataManager(strongSelf, didAskToIncrementAt: row)
        }
        return productCell
    }
    
    private func counterCell() -> ProductCounterCell? {
        let counterCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCounterCell.self)) as? ProductCounterCell
        counterCell?.configure(with: multipliableProducts)
        return counterCell
    }
}

// MARK: - Data Source
extension CartDataManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return multipliableProducts.isEmpty && !isInEditingMode ? 1 : CartTableSection.total
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = CartTableSection(rawValue: section) else { return 0 }
        switch section {
        case .products: return multipliableProducts.count
        case .counter: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = CartTableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .products: return productCell(at: indexPath.row) ?? UITableViewCell()
        case .counter: return counterCell() ?? UITableViewCell()
        }
    }
}

// MARK: - Delegate
extension CartDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = CartTableSection(rawValue: section), section == .counter else { return nil }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProductCounterHeader.self))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = CartTableSection(rawValue: section), section == .counter else { return 0.0 }
        return UITableViewAutomaticDimension
    }
    
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
        delegate?.cartDataManager(self, willDeleteProductAt: indexPath.row)
        removeProduct(at: indexPath.row)
        delegate?.cartDataManager(self, didDeleteProductAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
