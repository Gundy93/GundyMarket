//
//  CarouselImageCell.swift
//  GundyMarket
//
//  Created by Gundy on 4/2/24.
//

import UIKit

final class CarouselImageCell: UICollectionViewCell {
    static var reuseIdentifier: String { "CarouselImageCell" }
    
    // MARK: - Private  property
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
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
    
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    // MARK: - Private 
    
    private func configureHierarchy() {
        contentView.backgroundColor = .systemGray4
        contentView.addSubview(imageView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate(
            [
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ]
        )
    }
}

#Preview {
    let cell = CarouselImageCell()
    
    cell.setImage(image: UIImage(systemName: "basketball"))
    
    return cell
}
