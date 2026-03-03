//
//  SearchBar.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 14.02.26.
//

import UIKit
import SnapKit

class SearchBar: UIView {
    
    var onTextChanged: ((String) -> Void)?
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColor.secondaryText
        return iv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.card
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.stroke.cgColor
        return view
    }()
    
    
    init(icon: UIImage?, placeholder: String) {
        super.init(frame: .zero)
        
        iconImageView.image = icon
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: AppColor.secondaryText,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        
        setupUI()
        
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.tintColor = AppColor.secondaryText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(52)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        onTextChanged?(textField.text ?? "")
    }
    
}
