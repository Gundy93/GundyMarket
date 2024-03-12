//
//  ProductListViewModelDelegate.swift
//  GundyMarket
//
//  Created by Gundy on 3/12/24.
//

protocol ProductListViewModelDelegate: AnyObject {
    func setList(with products: [Product])
    func appendNewItems(_ product: [Product])
}
