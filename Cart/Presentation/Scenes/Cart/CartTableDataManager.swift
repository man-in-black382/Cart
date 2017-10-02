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
    func cartDataManager(_ manager: CartTableDataManager, didRemove product: Product, at index: Int)
}

typealias MultipliableProduct = (product: Product, multiplier: Int)

class CartTableDataManager: NSObject {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private(set) var multipliableProducts = [MultipliableProduct]()
    
    private var multipliableProductsBackStorage = [MultipliableProduct]()
    private var multipliableProductRealIndices = [Product: Int]()
    private var indicesToDelete = [Int]()
    private var isInEditingMode = false
    
    weak var delegate: CartDataManagerDelegate?

}

// MARK: - Public interface
extension CartTableDataManager {
    func addProduct(_ product: Product) {
        let multProduct = (product: product, multiplier: 1)
        multipliableProducts.append(multProduct)
        
        let latestIndex = multipliableProducts.count - 1
        let path = IndexPath(row: latestIndex, section: CartTableSection.products.rawValue)
        tableView.batchUpdates {
            tableView.insertRows(at: [path], with: .fade)
            toggleCounterSectionVisibilityIfNeeded()
            updateCounterCell()
        }
    }
    
    func toggleEditingModeOn() {
        // На случай, если пользователь свайпнул ячейку и включает редактирование
        tableView.setEditing(false, animated: true)
        
        multipliableProducts.enumerated().forEach { (arg) in
            let (index, multProduct) = arg
            multipliableProductRealIndices[multProduct.product] = index
        }
        multipliableProductsBackStorage = multipliableProducts
        
        isInEditingMode = true
        setMultiplierViewHiddenForAllCells(true)
        
        // Таблица с динамическими ячейками скачет и ведет себя неадекватно при вставке/удалении ячеек/секций.
        // Максимум, что пока удалось сделать, это отложить вставку/удаление секции со счетчиком товаров до
        // завершения анимации перехода/выхода в режим редактирования.
        // Если высота контента не превышает высоту таблицы, то все отрабатывает нормально
        CATransaction.commitNew(transaction: {
            tableView.setEditing(isInEditingMode, animated: true)
        }, completion: {
            self.toggleCounterSectionVisibilityIfNeeded()
        })
    }
    
    func commitEditModeChanges() -> [Product] {
        defer {
            toggleEditingModeOff()
            toggleCounterSectionVisibilityIfNeeded()
        }
        return indicesToDelete.map { multipliableProductsBackStorage[$0].product }
    }
    
    func discardEditModeChanges() {
        let paths = indicesToDelete.map { IndexPath(row: $0, section: CartTableSection.products.rawValue) }
        multipliableProducts = multipliableProductsBackStorage
        
        toggleEditingModeOff()
        
        tableView.batchUpdates {
            tableView.insertRows(at: paths, with: .fade)
            toggleCounterSectionVisibilityIfNeeded()
        }
    }
}

// MARK: - Private helpers
extension CartTableDataManager {
    
    // MARK: - UI
    
    private func setMultiplierViewHiddenForAllCells(_ hidden: Bool) {
        tableView.visibleCells.forEach {
            ($0 as? ProductCell)?.setMultiplierViewHidden(hidden, animated: true)
        }
    }
    
    private func toggleCounterSectionVisibilityIfNeeded() {
        if (isInEditingMode || multipliableProducts.isEmpty) && tableView.numberOfSections == CartTableSection.total {
            tableView.deleteSections(CartTableSection.counter.indexSet, with: .fade)
        } else if (!isInEditingMode && !multipliableProducts.isEmpty) && tableView.numberOfSections == 1 {
            tableView.insertSections(CartTableSection.counter.indexSet, with: .fade)
        }
    }
    
    private func updateCounterCell() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: CartTableSection.counter.rawValue)) as? ProductCounterCell
        cell?.configure(with: multipliableProducts)
    }
    
    // MARK: - Factory mothods
    
    private func productCell(at index: Int) -> ProductCell? {
        let productCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self)) as? ProductCell
        productCell?.configure(with: multipliableProducts[index])
        productCell?.decrementAction = { [weak self] cell in
            guard let strongSelf = self, let row = strongSelf.tableView.indexPath(for: cell)?.row else { return }
            strongSelf.setMultiplier(strongSelf.multipliableProducts[row].multiplier - 1, forProductAt: row)
        }
        productCell?.incrementAction = { [weak self] cell in
            guard let strongSelf = self, let row = strongSelf.tableView.indexPath(for: cell)?.row else { return }
            strongSelf.setMultiplier(strongSelf.multipliableProducts[row].multiplier + 1, forProductAt: row)
        }
        productCell?.setMultiplierViewHidden(isInEditingMode, animated: false)
        return productCell
    }
    
    private func counterCell() -> ProductCounterCell? {
        let counterCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCounterCell.self)) as? ProductCounterCell
        counterCell?.configure(with: multipliableProducts)
        return counterCell
    }
    
    // MARK: - Data manipulation
    
    private func removeProduct(at index: Int) {
        if isInEditingMode {
            if let realIndex = multipliableProductRealIndices[multipliableProducts[index].product] {
                indicesToDelete.append(realIndex)
            }
        }
        
        let deletedMultipliableProduct = multipliableProducts.remove(at: index)
        let path = IndexPath(row: index, section: CartTableSection.products.rawValue)
        
        tableView.batchUpdates {
            tableView.deleteRows(at: [path], with: .left)
            toggleCounterSectionVisibilityIfNeeded()
            updateCounterCell()
        }
        
        if !isInEditingMode {
            delegate?.cartDataManager(self, didRemove: deletedMultipliableProduct.product, at: index)
        }
    }
    
    private func setMultiplier(_ multiplier: Int, forProductAt index: Int) {
        guard multiplier > 0 else { return }
        
        multipliableProducts[index].multiplier = multiplier
        let path = IndexPath(row: index, section: CartTableSection.products.rawValue)
        let cell = tableView.cellForRow(at: path) as? ProductCell
        cell?.multiplier = multiplier
        updateCounterCell()
    }
    
    private func toggleEditingModeOff() {
        multipliableProductsBackStorage.removeAll()
        multipliableProductRealIndices.removeAll()
        indicesToDelete.removeAll()
        isInEditingMode = false
        tableView.setEditing(false, animated: true)
        setMultiplierViewHiddenForAllCells(false)
    }
}

// MARK: - Data Source
extension CartTableDataManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return multipliableProducts.isEmpty || isInEditingMode ? 1 : CartTableSection.total
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
extension CartTableDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = CartTableSection(rawValue: section), section == .counter else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProductCounterHeader.self))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = CartTableSection(rawValue: section), section == .counter else { return 0.01 }
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
        removeProduct(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
