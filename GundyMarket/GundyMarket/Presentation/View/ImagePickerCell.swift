//
//  ImagePickerCell.swift
//  GundyMarket
//
//  Created by Gundy on 4/11/24.
//

import UIKit

final class ImagePickerCell: UICollectionViewCell {
    static var reuseIdentifier: String { "ImagePickerCell" }
    
    // MARK: - Private property
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let cameraImageView: UIImageView = {
        let cameraImage = UIImage(systemName: "camera.fill") 
        let imageView = UIImageView(image: cameraImage)
        
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray2
        
        return label
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
    
    func setCount(_ count: Int) {
        let text = "\(count)/5"
        let attributedText = NSMutableAttributedString(string: text)
        var range = NSRange()
        
        switch count {
        case 0:
            break
        default:
            range = (text as NSString).range(of: String(count))
        }
        
        attributedText.addAttribute(
            .foregroundColor,
            value: UIColor.orange,
            range: range
        )
        countLabel.attributedText = attributedText
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        contentView.addSubview(contentStackView)
        [cameraImageView, countLabel].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cameraImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3)
        ])
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 0.5
    }
}

#Preview {
    let cell = ImagePickerCell()
    
    cell.setCount(5)
    
    return cell
}
