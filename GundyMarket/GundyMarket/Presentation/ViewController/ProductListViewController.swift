//
//  ProductListViewController.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import UIKit

final class ProductListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Product> 
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Product>
    
    // MARK: - Private property
    
    private let productCollectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            ProductListCell.self,
            forCellWithReuseIdentifier: ProductListCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    private var dataSource: DataSource?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureDataSource()
    }
    
    // MARK: - Public
    
    func setSnapshot(with products: [Product]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        dataSource?.apply(snapshot)
    }
    
    func appendSnapshotItems(_ product: [Product]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        snapshot.appendItems(product)
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        view.addSubview(productCollectionView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [
                productCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                productCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                productCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                productCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ]
        )
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: productCollectionView) { collectionView, indexPath, product in 
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCell.reuseIdentifier,
                for: indexPath
            ) as? ProductListCell else { return ProductListCell() }
            
            cell.setThumbnail(image: nil)
            cell.setTexts(
                name: product.name,
                date: product.issuedAt,
                price: String(product.price)
            )
            
            return cell
        }
    }
}

#Preview {
    let viewController = ProductListViewController()
    
    Task {
        viewController.setSnapshot(
            with: [
                .init(
                    id: 2456,
                    vendorName: "zhilly",
                    name: "사진 모음집",
                    description: "AI로 그린 사진 모음입니다",
                    thumbnailURL: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/48/20240207/b5b494eac59a11eeaa7e89c63665c7a3_thumb.png",
                    currency: .krw,
                    price: 1000,
                    issuedAt: "2024-02-07T00:00:00",
                    isEdited: false
                )
            ]
        )
    }
    
    return viewController
}
