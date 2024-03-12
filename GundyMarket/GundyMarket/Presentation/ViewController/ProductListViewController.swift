//
//  ProductListViewController.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import UIKit

final class ProductListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Product>
    
    // MARK: - Private property
    
    private let viewModel: GundyMarketViewModel
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
    private var isLoading = true
    
    // MARK: - Lifecycle
    
    init(viewModel: GundyMarketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureCollectionView()
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
    
    private func configureCollectionView() {
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
        
        viewModel.loadNewList()
        productCollectionView.delegate = self
    }
}

extension ProductListViewController: ProductListViewModelDelegate {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Product>
    
    // MARK: - Public
    
    func setList(with products: [Product]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        dataSource?.apply(snapshot)
        isLoading = false
    }
    
    func appendNewItems(_ product: [Product]) {
        guard var snapshot = dataSource?.snapshot() else { return }
        
        snapshot.appendItems(product)
        dataSource?.apply(snapshot)
        isLoading = false
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isLoading == false,
              scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height * 2 else { return }
        
        isLoading = true
        viewModel.loadMoreList()
    }
}

#Preview {
    let viewModel = GundyMarketViewModel(networkManager: .init(session: NetworkSession(session: .shared)))
    let viewController = ProductListViewController(viewModel: viewModel)
    
    return viewController
}
