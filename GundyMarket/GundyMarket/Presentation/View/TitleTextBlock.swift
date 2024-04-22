//
//  TitleTextBlock.swift
//  GundyMarket
//
//  Created by Gundy on 4/6/24.
//

import UIKit

final class TitleTextBlock: UIView {
    
    // MARK: - Public property
    
    var text: String { textView.text }
    
    // MARK: - Private property
    
    private let title: String
    private let placeholder: String?
    private let isDecimalField: Bool
    private let numberFormatter: NumberFormatter?
    private let isMultiline: Bool
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(
            ofSize: 15,
            weight: .semibold
        )
        
        return label
    }()
    private let outlineView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 0.5
        
        return view
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private let cautionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isHidden = true
        
        return label
    }()
    private var isCaution: Bool = false
    
    // MARK: - Lifecyle
    
    init(
        title: String,
        placeholder: String?,
        isDecimalField: Bool = false,
        isMultiline: Bool,
        caution text: String
    ) {
        self.title = title
        self.placeholder = placeholder
        self.isDecimalField = isDecimalField
        self.isMultiline = isMultiline
        cautionLabel.text = text
        
        if isDecimalField {
            numberFormatter = NumberFormatter()
            numberFormatter?.numberStyle = .decimal
        } else {
            numberFormatter = nil
        }
        
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureTitleLabel()
        configureTextView()
        configurePlaceholderLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    func setText(_ text: String) {
        textView.text = text
        textViewDidChange(textView)
    }
    
    func validate() -> Bool {
        guard textView.text.isEmpty == false else {
            setIsCaution(true)
            
            return false
        }
        
        return true
    }
    
    // MARK: - Private
    
    private func configureHierarchy() {
        addSubview(contentStackView)
        [titleLabel, outlineView, cautionLabel].forEach { contentStackView.addArrangedSubview($0) }
        [textView, placeholderLabel].forEach { outlineView.addSubview($0) }
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            outlineView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: outlineView.topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: outlineView.leadingAnchor, constant: 9),
            placeholderLabel.trailingAnchor.constraint(equalTo: outlineView.trailingAnchor, constant: -9),
            
            textView.topAnchor.constraint(equalTo: outlineView.topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: outlineView.leadingAnchor, constant: 4),
            textView.trailingAnchor.constraint(equalTo: outlineView.trailingAnchor, constant: -4),
            textView.bottomAnchor.constraint(equalTo: outlineView.bottomAnchor, constant: -12),
            isMultiline ? textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 102) : textView.heightAnchor.constraint(equalToConstant: 17),
        ])
        
        textView.textContainerInset = .zero
    }
    
    private func configureTitleLabel() {
        titleLabel.text = title
    }
    
    private func configureTextView() {
        textView.font = .systemFont(ofSize: 17)
        textView.delegate = self
        textView.keyboardType = isDecimalField ? .numberPad : .default
        textView.isScrollEnabled = false
    }
    
    private func configurePlaceholderLabel() {
        placeholderLabel.text = placeholder
    }
    
    private func setIsCaution(_ isCaution: Bool) {
        guard self.isCaution != isCaution else { return }
        
        if isCaution {
            outlineView.layer.borderWidth = 1
            outlineView.layer.borderColor = UIColor.systemRed.cgColor
            outlineView.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.8, alpha: 1)
            textView.backgroundColor = UIColor(red: 1, green: 0.9, blue: 0.8, alpha: 1)
            cautionLabel.isHidden = false
        } else {
            outlineView.layer.borderWidth = 0.5
            outlineView.layer.borderColor = UIColor.systemGray2.cgColor
            outlineView.backgroundColor = nil
            textView.backgroundColor = nil
            cautionLabel.isHidden = true
        }
        
        self.isCaution = isCaution
    }
}

extension TitleTextBlock: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setIsCaution(false)
        outlineView.layer.borderColor = UIColor.label.cgColor
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        outlineView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n",
           isMultiline == false {
            textView.text.removeLast()
        }
        
        if textView.text.isEmpty,
           placeholderLabel.isHidden {
            placeholderLabel.isHidden = false
        }
        
        if textView.text.isEmpty == false,
           placeholderLabel.isHidden == false {
            placeholderLabel.isHidden = true
        }
        
        if isDecimalField { formatNumber() }
    }
    
    private func formatNumber() {
        let text = textView.text.replacingOccurrences(
            of: ",",
            with: ""
        )
        guard let number = numberFormatter?.number(from: text) else { return }
        
        textView.text = numberFormatter?.string(from: number)
    }
}

#Preview {
    let view = TitleTextBlock(
        title: "가격",
        placeholder: "가격을 입력해주세요.",
        isDecimalField: true,
        isMultiline: false,
        caution: "가격을 입력해주세요."
    )
    
    _ = view.validate()
    
    return view
}
