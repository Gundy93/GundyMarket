//
//  DetailViewController.swift
//  GundyMarket
//
//  Created by Gundy on 3/19/24.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Private property
    
    private let isVendor: Bool
    private let viewModel: GundyMarketViewModel
    private var headerHeight = CGFloat.zero
    private var headerHeightConstraint: NSLayoutConstraint?
    private var isClear = false
    private var shadowLayers = [CALayer]()
    private let stickyHeaderCarouselCollectionView: UICollectionView = {
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            section.contentInsetsReference = .none
            
            return section
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        configuration.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: configuration
        )
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentMode = .scaleToFill
        collectionView.register(
            CarouselImageCell.self,
            forCellWithReuseIdentifier: CarouselImageCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    private let pageControl = UIPageControl()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 8
        
        return stackView
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill"))
        
        imageView.tintColor = .init(white: 0.975, alpha: 1)
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let vendorNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    private let divider: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 21)
        label.numberOfLines = 0
        
        return label
    }()
    private let dateLabel:UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        
        return label
    }()
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        return label
    }()
    private let footerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 0.5
        
        return view
    }()
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    
    init(
        vendorID: Int,
        viewModel: GundyMarketViewModel
    ) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        isVendor = vendorID == appDelegate?.user.id
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
        viewModel.detailDelegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        headerHeight = view.frame.height*0.45
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureCollectionView()
        configurePageControl()
        setShadow()
        configureScrollView()
        setLabelTexts()
        
        if isVendor {
            addVendorButton()
        }
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        [scrollView, stickyHeaderCarouselCollectionView, pageControl, footerView, activityIndicatorView].forEach {
            view.addSubview($0)
        }
        scrollView.addSubview(contentStackView)
        footerView.addSubview(footerStackView)
        footerStackView.addArrangedSubview(priceLabel)
        [profileStackView, divider, nameLabel, dateLabel, descriptionLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        [profileImageView, vendorNameLabel].forEach {
            profileStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            stickyHeaderCarouselCollectionView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
            stickyHeaderCarouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyHeaderCarouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyHeaderCarouselCollectionView.bottomAnchor.constraint(equalTo: contentStackView.topAnchor, constant: -20),
            
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            footerStackView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 20),
            footerStackView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -20),
            footerStackView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            footerStackView.bottomAnchor.constraint(equalTo: 
                                                        safeArea.bottomAnchor, constant: -20),
            
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.bottomAnchor.constraint(equalTo: stickyHeaderCarouselCollectionView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: stickyHeaderCarouselCollectionView.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: stickyHeaderCarouselCollectionView.trailingAnchor),
        ])
        
        headerHeightConstraint = stickyHeaderCarouselCollectionView.heightAnchor.constraint(equalToConstant: headerHeight)
        headerHeightConstraint?.isActive = true
        activityIndicatorView.center = view.center
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.standardAppearance.backgroundEffect = .none
    }
    
    private func configureCollectionView() {
        stickyHeaderCarouselCollectionView.delegate = self
        stickyHeaderCarouselCollectionView.dataSource = self
    }
    
    private func configurePageControl() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 50
        )
        gradientLayer.colors = [UIColor.clear.cgColor, CGColor(gray: 0, alpha: 0.1)]
        gradientLayer.endPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        shadowLayers.append(gradientLayer)
        pageControl.layer.addSublayer(gradientLayer)
        pageControl.isHidden = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(
            self,
            action: #selector(scrollToPage),
            for: .valueChanged
        )
    }
    
    private func setShadow() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 120
        )
        gradientLayer.colors = [CGColor(gray: 0, alpha: 0.1), UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(
            x: 0.5,
            y: 0.5
        )
        shadowLayers.append(gradientLayer)
        view.layer.addSublayer(gradientLayer)
    }
    
    private func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset.top = headerHeight
    }
    
    private func setLabelTexts() {
        guard let product = viewModel.product else { return }
        
        vendorNameLabel.text = product.vendor.name
        nameLabel.text = product.name
        dateLabel.text = (product.isEdited ? "수정 " : "") + viewModel.string(for: product.issuedAt)
        descriptionLabel.text = product.description
        priceLabel.text = product.priceText + (product.currency == .krw ? "원" : "달러")
    }
    
    @objc
    private func scrollToPage() {
        let x = stickyHeaderCarouselCollectionView.frame.width * CGFloat(pageControl.currentPage)
        stickyHeaderCarouselCollectionView.setContentOffset(
            CGPoint(
                x: x,
                y: .zero
            ),
            animated: true
        )
    }
    
    private func addVendorButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            primaryAction: UIAction { [weak self] _ in 
                self?.showVendorActionSheet()
            }
        )
    }
    
    private func showVendorActionSheet() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let delete = UIAlertAction(
            title: "삭제",
            style: .destructive) { [weak self] _ in
                self?.presentDeleteAlert()
            }
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        
        [delete, cancel].forEach { alertController.addAction($0) }
        present(
            alertController,
            animated: true
        )
    }
    
    private func presentDeleteAlert() {
        let alertController = UIAlertController(
            title: nil,
            message: "게시글을 삭제할까요?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        let delete = UIAlertAction(
            title: "삭제",
            style: .destructive) { [weak self] _ in
                Task {
                    self?.activityIndicatorView.startAnimating()
                    
                    do {
                        try await self?.viewModel.deleteProduct()
                        self?.navigationController?.popViewController(animated: true)
                    } catch {
                        self?.activityIndicatorView.stopAnimating()
                        self?.presentErrorAlert(error)
                    }
                }
            }
        
        [delete, cancel].forEach { alertController.addAction($0) }
        present(
            alertController,
            animated: true
        )
    }
    
    private func presentErrorAlert(_ error: Error) {
        let alertController = UIAlertController(
            title: error.localizedDescription,
            message: "잠시 후 다시 시도해 주세요.",
            preferredStyle: .alert
        )
        let close = UIAlertAction(
            title: "닫기",
            style: .default
        )
        
        alertController.addAction(close)
        present(
            alertController,
            animated: true
        )
    }
}

extension DetailViewController: ProductDetailViewModelDelegate {
    func setProduct() {
        setLabelTexts()
    }
    
    func setImageDatas() {
        stickyHeaderCarouselCollectionView.reloadData()
        stickyHeaderCarouselCollectionView.isScrollEnabled = viewModel.imageDatas.count > 1
        pageControl.numberOfPages = viewModel.imageDatas.count
        pageControl.isHidden = viewModel.imageDatas.count == 1
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.imageDatas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarouselImageCell.reuseIdentifier,
            for: indexPath
        ) as? CarouselImageCell else { return CarouselImageCell() }
        
        cell.setImage(image: UIImage(data: viewModel.imageDatas[indexPath.item]))
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            contentScrollViewDidScroll()
        } else {
            collectionViewDidScroll()
        }
    }
    
    private func contentScrollViewDidScroll() {
        if scrollView.contentOffset.y <= -headerHeight {
            headerHeightConstraint?.constant = -scrollView.contentOffset.y
            
            if pageControl.numberOfPages > 1, pageControl.isHidden == false {
                pageControl.isHidden = true
            }
        } else if pageControl.numberOfPages > 1, pageControl.isHidden {
            pageControl.isHidden = false
        }
        
        if scrollView.contentOffset.y >= -150,
           isClear {
            isClear = false
            navigationController?.navigationBar.standardAppearance.backgroundColor = .systemBackground
            navigationController?.navigationBar.standardAppearance.shadowColor = .separator
            navigationController?.navigationBar.tintColor = .label
            shadowLayers.last?.isHidden = true
        } else if scrollView.contentOffset.y < -150,
                  isClear == false {
            isClear = true
            navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
            navigationController?.navigationBar.standardAppearance.shadowColor = .clear
            navigationController?.navigationBar.tintColor = .systemBackground
            shadowLayers.last?.isHidden = false
        }
    }
    
    private func collectionViewDidScroll() {
        guard stickyHeaderCarouselCollectionView.isDragging else { return }
        pageControl.currentPage = Int(stickyHeaderCarouselCollectionView.contentOffset.x / stickyHeaderCarouselCollectionView.frame.width)
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
    
    Task {
        await viewModel.setProduct(2485)
    }
    
    return UINavigationController(rootViewController: DetailViewController(
        vendorID: 43,
        viewModel: viewModel
    ))
}

