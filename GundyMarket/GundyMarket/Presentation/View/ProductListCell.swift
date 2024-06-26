//
//  ProductListCell.swift
//  GundyMarket
//
//  Created by Gundy on 3/5/24.
//

import UIKit

final class ProductListCell: UICollectionViewListCell {
    static var reuseIdentifier: String { "ProductListCell" }
    
    // MARK: - Private property
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 16
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 19, weight: .thin)
        
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 19, weight: .bold)
        
        return label
    }()
    private var id: Int?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setId(_ id: Int?) {
        self.id = id
    }
    
    func setTexts(name: String, date: String, price: String) {
        nameLabel.text = name
        dateLabel.text = date
        priceLabel.text = price
    }
    
    func setThumbnail(image: UIImage?, for id: Int?) {
        guard id == self.id else { return }
        
        thumbnailImageView.image = image
    }
    
    // MARK: - Private 
    
    private func configureHierarchy() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(thumbnailImageView)
        contentStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(priceLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate(
            [
                contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                thumbnailImageView.widthAnchor.constraint(equalToConstant: 120),
                
                separatorLayoutGuide.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
                separatorLayoutGuide.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            ]
        )
        
        let ratioConstraint = thumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.widthAnchor)
        
        ratioConstraint.priority = .defaultHigh
        ratioConstraint.isActive = true
    }
}

#Preview {
    let cell = ProductListCell()
    
    cell.setId(1)
    cell.setTexts(
        name: "농구공 판매",
        date: "1일 전",
        price: "5,000원"
    )
    cell.setThumbnail(
        image: UIImage(
            systemName: "basketball"
        ),
        for: 1
    )
    
    return cell
}
