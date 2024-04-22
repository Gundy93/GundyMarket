//
//  ProductImageCell.swift
//  GundyMarket
//
//  Created by Gundy on 4/11/24.
//

import UIKit

final class ProductImageCell: UICollectionViewCell {
    static var reuseIdentifier: String { "ProductImageCell" }
    
    // MARK: - Public property
    
    weak var delegate: ProductImageCellDelegate?
    
    // MARK: - Private property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    private let representativeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "대표 사진"
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        label.backgroundColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let removeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(
            UIImage(systemName: "xmark.circle.fill"),
            for: .normal
        )
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private var item: Int = 0
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: = Public
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func setItem(_ item: Int) {
        representativeLabel.isHidden = item != 0
        self.item = item
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        [imageView, removeButton].forEach { contentView.addSubview($0) }
        imageView.addSubview(representativeLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            representativeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            representativeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            representativeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            removeButton.centerXAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: contentView.topAnchor),
            removeButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor),
        ])
        
        contentView.clipsToBounds = false
    }
    
    private func configureButton() {
        removeButton.addTarget(
            self,
            action: #selector(remove),
            for: .touchUpInside
        )
    }
    
    @objc
    private func remove() {
        delegate?.remove(item)
    }
}

#Preview {
    let cell = ProductImageCell()
    
    cell.setImage(UIImage.checkmark)
    
    return cell
}
