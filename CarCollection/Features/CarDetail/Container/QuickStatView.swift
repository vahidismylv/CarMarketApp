//
//  QuickStatView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 17.02.26.
//

import UIKit
import SnapKit

final class QuickStatView: UIView {
    
    private let iconView = UIImageView()
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    
    init(iconName: String, value: String, title: String) {
        super.init(frame: .zero)
        setupUI()
        configure(iconName: iconName, value: value, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppColor.card
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = AppColor.stroke.cgColor
        clipsToBounds = true
        
        
        iconView.tintColor = AppColor.secondaryText
        iconView.contentMode = .scaleAspectFit
        
        valueLabel.font = .systemFont(ofSize: 14, weight: .bold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.numberOfLines = 1
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.75
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = AppColor.secondaryText
        titleLabel.numberOfLines = 1
        
        addSubview(iconView)
        addSubview(valueLabel)
        addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    private func configure(iconName: String, value: String, title: String) {
        iconView.image = UIImage(systemName: iconName)
        valueLabel.text = value
        titleLabel.text = title
    }
}
