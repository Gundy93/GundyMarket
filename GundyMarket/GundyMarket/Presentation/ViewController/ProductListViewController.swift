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
    private let productAddButton: UIButton = {
        let configuration = UIButton.Configuration.filled()
        let button = UIButton(configuration: configuration)
        
        button.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        button.setTitle(
            "글쓰기",
            for: .normal
        )
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.background.backgroundColor = .systemOrange
            case .highlighted:
                button.configuration?.background.backgroundColor = UIColor(
                    red: 1,
                    green: 0.75,
                    blue: 0.5,
                    alpha: 1
                )
            default:
                return
            }
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = button.intrinsicContentSize.height/2+5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let productCollectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
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
        super.init(
            nibName: nil,
            bundle: nil
        )
        viewModel.listDelegate = self
        title = ""
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
        configureRefreshControl()
        configureProductAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reset()
        navigationController?.navigationBar.isHidden = true
        handleRefreshControl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        [productCollectionView, productAddButton].forEach { view.addSubview($0) }
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [
                productCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                productCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                productCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                productCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                
                productAddButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
                productAddButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
                productAddButton.widthAnchor.constraint(equalToConstant: productAddButton.intrinsicContentSize.width),
                productAddButton.heightAnchor.constraint(equalToConstant: productAddButton.intrinsicContentSize.height+10),
            ]
        )
    }
    
    private func configureCollectionView() {
        productCollectionView.delegate = self
        dataSource = DataSource(collectionView: productCollectionView) { collectionView, indexPath, product in 
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCell.reuseIdentifier,
                for: indexPath
            ) as? ProductListCell else { return ProductListCell() }
            
            cell.setId(product.id)
            cell.setTexts(
                name: product.name,
                date: (product.isEdited ? "수정 " : "") + self.viewModel.string(for: product.issuedAt),
                price: product.priceText + (product.currency == .krw ? "원" : "달러")
            )
            cell.setThumbnail(image: nil, for: product.id)
            Task {
                guard let data = await self.viewModel.data(for: product.thumbnailURL),
                      let image = UIImage(data: data) else { return }
                
                cell.setThumbnail(
                    image: image,
                    for: product.id
                )
            }
            
            return cell
        }
        
        Task {
            await viewModel.loadNewList()
        }
    }
    
    private func configureRefreshControl() {
        productCollectionView.refreshControl = .init()
        productCollectionView.refreshControl?.tintColor = .systemOrange
        productCollectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }
    
    @objc
    func handleRefreshControl() {
        isLoading = true
        
        Task {
            await viewModel.loadNewList()
            try? await Task.sleep(nanoseconds: 500000000)
            self.productCollectionView.refreshControl?.endRefreshing()
            isLoading = false
        }
    }
    
    private func configureProductAddButton() {
        productAddButton.addTarget(
            self,
            action: #selector(presentProductAddViewController),
            for: .touchUpInside
        )
    }
    
    @objc
    func presentProductAddViewController() {
        let viewController = ProductAddViewController(viewModel: viewModel)
        
        viewController.modalPresentationStyle = .fullScreen
        present(
            viewController,
            animated: true
        )
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
        Task {
            await viewModel.loadMoreList()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let productId = dataSource?.itemIdentifier(for: indexPath)?.id,
              let vendorID = dataSource?.itemIdentifier(for: indexPath)?.vendor.id else { return }
        
        Task {
            await viewModel.setProduct(productId)
        }
        
        navigationController?.pushViewController(
            DetailViewController(
                vendorID: vendorID,
                viewModel: viewModel
            ),
            animated: true
        )
        
        collectionView.deselectItem(
            at: indexPath,
            animated: true
        )
    }
}

#Preview {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let imageCacheManager = ImageDataCacheManager(
        memoryCache: Cache(
            storage: NSCacheStorage(
                nsCache: .init()
            )
        ),
        session: NetworkSession(
            session: .shared
        )
    )
    
    let networkManager = NetworkManager(
        session: NetworkSession(
            session: .shared
        )
    )
    
    let viewModel = GundyMarketViewModel(
        numberFormatter: numberFormatter,
        dateFormatter: dateFormatter,
        imageCacheManager: imageCacheManager,
        networkManager: networkManager
    )
    
    return UINavigationController(rootViewController: ProductListViewController(viewModel: viewModel)) 
}
