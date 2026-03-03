//
//  AuthTextField.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 12.02.26.
//

import UIKit
import SnapKit

class AuthTextField: UIView {
    
    private let iconContainerView: UIView = {
         let view = UIView()
         view.backgroundColor = AppColor.stroke
         view.layer.cornerRadius = 19
         return view
     }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()
    
    private lazy var toggleSecureButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "eye"), for: .normal)
        btn.tintColor = AppColor.secondaryText
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        return btn
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.card
        view.layer.cornerRadius = 26
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.stroke.cgColor
        return view
    }()
    
    private var isSecureField: Bool = false
    private var placeholderText: String = ""
    
    init(icon: UIImage?, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)
        
        iconImageView.image = icon
        textField.isSecureTextEntry = isSecure
        self.isSecureField = isSecure
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
            .foregroundColor: AppColor.secondaryText,
            .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
    
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconContainerView)
        iconContainerView.addSubview(iconImageView)
        containerView.addSubview(textField)

        if isSecureField {
            containerView.addSubview(toggleSecureButton)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(52)
        }

        iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.size.equalTo(38)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18)
        }

        if isSecureField {
            toggleSecureButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().inset(20)
//                make.centerY.equalToSuperview()
                make.size.equalTo(18)
            }

            textField.snp.makeConstraints { make in
                make.leading.equalTo(iconContainerView.snp.trailing).offset(12)
                make.trailing.equalTo(toggleSecureButton.snp.leading).inset(20)
                make.centerY.equalToSuperview()
            }
        } else {
            textField.snp.makeConstraints { make in
                make.leading.equalTo(iconContainerView.snp.trailing).offset(12)
                make.trailing.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
        }
    }
}

extension AuthTextField {
    func setErrorState() {
        containerView.layer.borderColor = UIColor.systemRed.cgColor
            containerView.layer.borderWidth = 1
        }
    
    func setNormalState() {
        containerView.layer.borderColor = AppColor.stroke.cgColor
    }
  
}
