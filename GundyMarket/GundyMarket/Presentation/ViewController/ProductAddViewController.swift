//
//  ProductAddViewController.swift
//  GundyMarket
//
//  Created by Gundy on 4/6/24.
//

import PhotosUI

final class ProductAddViewController: UIViewController {
    
    // MARK: - Private property
    
    private let viewModel: GundyMarketViewModel
    private let navigationBar = UINavigationBar()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let imageCollectionView: UICollectionView = {
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            section.interGroupSpacing = 8
            
            return section
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        configuration.scrollDirection = .horizontal
        configuration.interSectionSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: configuration
        )
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.register(
            ImagePickerCell.self,
            forCellWithReuseIdentifier: ImagePickerCell.reuseIdentifier
        )
        collectionView.register(
            ProductImageCell.self,
            forCellWithReuseIdentifier: ProductImageCell.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        
        return collectionView
    }()
    private let cautionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        label.text = "최소 1장의 사진이 필요합니다."
        
        return label
    }()
    private let titleTextFiled = TitleTextBlock(
        title: "제목",
        placeholder: "제목",
        isMultiline: false,
        caution: "제목을 적어주세요."
    )
    private let priceTextFiled = TitleTextBlock(
        title: "가격",
        placeholder: "가격을 입력해주세요.",
        isDecimalField: true,
        isMultiline: false,
        caution: "가격을 입력해주세요."
    )
    private let descriptionTextView = TitleTextBlock(
        title: "자세한 설명",
        placeholder: "신뢰할 수 있는 거래를 위해 자세히 적어주세요.",
        isMultiline: true,
        caution: "설명을 자세히 적어주세요."
    )
    private let footerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private let doneButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var images = [UIImage]() {
        didSet { imageCollectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: GundyMarketViewModel) {
        self.viewModel = viewModel
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureCollectionView()
        configureDoneButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if cautionLabel.isHidden == false {
            cautionLabel.isHidden = true
            contentStackView.setCustomSpacing(20, after: imageCollectionView)
        }
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        [navigationBar, scrollView, footerView, activityIndicatorView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)
        [imageCollectionView, cautionLabel, titleTextFiled, priceTextFiled, descriptionTextView].forEach { contentStackView.addArrangedSubview($0) }
        footerView.addSubview(doneButton)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            
            imageCollectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8),
            doneButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        activityIndicatorView.center = view.center
    }
    
    private func configureNavigationBar() {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let delegate = scene.delegate as? SceneDelegate,
              let topInset = delegate.window?.safeAreaInsets.top else { return }
        
        let navigationTitle = "내 물건 팔기"
        let navigationItem = UINavigationItem(title: navigationTitle)
        
        navigationBar.frame = .init(
            x: 0,
            y: topInset,
            width: view.frame.width,
            height: 44
        )
        navigationBar.isTranslucent = false
        navigationBar.items = [navigationItem]
        navigationBar.titleTextAttributes = [
            .font : UIFont.systemFont(
                ofSize: 17,
                weight: .semibold
            )
        ]
        navigationItem.leftBarButtonItem = .init(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissViewController)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    @objc
    private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func configureCollectionView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(
            "작성 완료",
            for: .normal
        )
        doneButton.titleLabel?.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        doneButton.layer.cornerRadius = 8
        doneButton.addTarget(
            self,
            action: #selector(done),
            for: .touchUpInside
        )
    }
    
    @objc
    private func done() {
        guard validate() else { return }
        
        Task {
            activityIndicatorView.startAnimating()
            
            do {
                try await viewModel.addProduct(
                    name: titleTextFiled.text,
                    description: descriptionTextView.text,
                    price: priceTextFiled.text,
                    images: images.compactMap { compress(image: $0) }
                )
                dismissViewController()
            } catch {
                activityIndicatorView.stopAnimating()
                presentErrorAlert(error)
            }
        }
    }
    
    private func validate() -> Bool {
        guard images.isEmpty == false else {
            cautionLabel.isHidden = false
            contentStackView.setCustomSpacing(8, after: imageCollectionView)
            
            return false
        }
        
        for textBlock in [titleTextFiled, priceTextFiled, descriptionTextView] {
            if textBlock.validate() == false {
                return false
            }
        }
        
        return true
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
    
    private func compress(image: UIImage) -> Data? {
        var result = image.jpegData(compressionQuality: 1)
        
        if result!.count > 300000 {
            result = image.jpegData(compressionQuality: 0.1)
        }
        
        return result
    }
}

extension ProductAddViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return images.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImagePickerCell.reuseIdentifier,
                for: indexPath
            ) as? ImagePickerCell else { return ImagePickerCell() }
            
            cell.setCount(images.count)
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductImageCell.reuseIdentifier,
                for: indexPath
            ) as? ProductImageCell else { return ProductImageCell() }
            
            cell.setImage(images[indexPath.item])
            cell.setItem(indexPath.item)
            cell.delegate = self
            
            return cell
        }
    }
}

extension ProductAddViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        defer {
            collectionView.deselectItem(
                at: indexPath,
                animated: true
            )
        }
        
        guard indexPath.section == 0 else { return }
        
        guard images.count < 5 else {
            presentImageAlert()
            return
        }
        
        presentPHPicker()
    }
    
    private func presentImageAlert() {
        let alertController = UIAlertController(
            title: "알림",
            message: "이미지는 최대 5장까지 첨부할 수 있어요.",
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
    
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        
        configuration.filter = .images
        configuration.selectionLimit = 5-images.count
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(
            picker,
            animated: true
        )
    }
}

extension ProductAddViewController: PHPickerViewControllerDelegate {
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        dismiss(animated: true)
        
        let itemProviders = results.map(\.itemProvider).filter { $0.canLoadObject(ofClass: UIImage.self) }
        let count = images.count
        
        images += Array(
            repeating: UIImage(),
            count: itemProviders.count
        )
        
        for (index, itemProvider) in itemProviders.enumerated() {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    
                    self?.images[index + count] = image.resize(720)
                }
            }
        }
    }
}

extension ProductAddViewController: ProductImageCellDelegate {
    func remove(_ item: Int) {
        images.remove(at: item)
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
    
    return ProductAddViewController( viewModel: viewModel)
}
