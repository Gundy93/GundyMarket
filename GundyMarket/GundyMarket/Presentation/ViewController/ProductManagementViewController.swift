//
//  ProductManagementViewController.swift
//  GundyMarket
//
//  Created by Gundy on 4/6/24.
//

import UIKit

final class ProductManagementViewController: UIViewController {
    
    // MARK: - Private property
    
    private let isNewProduct: Bool
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
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let titleTextFiled = TitleTextBlock(
        title: "제목",
        placeholder: "제목",
        isMultiline: false
    )
    private let priceTextFiled = TitleTextBlock(
        title: "가격",
        placeholder: "가격을 입력해주세요.",
        isDecimalField: true,
        isMultiline: false
    )
    private let descriptionTextView = TitleTextBlock(
        title: "자세한 설명",
        placeholder: "신뢰할 수 있는 거래를 위해 자세히 적어주세요.",
        isMultiline: true
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
    
    // MARK: - Lifecycle
    
    init(isNewProduct: Bool) {
        self.isNewProduct = isNewProduct
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureDoneButton()
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        [navigationBar, scrollView, footerView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)
        [titleTextFiled, priceTextFiled, descriptionTextView].forEach { contentStackView.addArrangedSubview($0) }
        footerView.addSubview(doneButton)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            doneButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8),
            doneButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureNavigationBar() {
//        guard let scene = UIApplication.shared.connectedScenes.first,
//              let delegate = scene.delegate as? SceneDelegate,
//              let topInset = delegate.window?.safeAreaInsets.top else { return }
        let navigationTitle = isNewProduct ? "내 물건 팔기" : "중고거래 글 수정하기"
        let navigationItem = UINavigationItem(title: navigationTitle)
        
        navigationBar.frame = .init(
            x: 0,
            y: 59,
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
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(
            isNewProduct ? "작성 완료" : "수정 완료",
            for: .normal
        )
        doneButton.titleLabel?.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        doneButton.layer.cornerRadius = 8
    }
}

#Preview {
    ProductManagementViewController(isNewProduct: true)
}
