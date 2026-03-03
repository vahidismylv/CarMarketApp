//
//  SpecRowView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 17.02.26.
//

import UIKit
import SnapKit

final class SpecRowView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(title: String, value: String) {
        super.init(frame: .zero)
        setupUI()
        titleLabel.text = title
        valueLabel.text = value
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = AppColor.secondaryText
        titleLabel.numberOfLines = 1

        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = AppColor.primaryText
        valueLabel.numberOfLines = 2
        valueLabel.textAlignment = .right

        addSubview(titleLabel)
        addSubview(valueLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-12)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
            make.width.greaterThanOrEqualTo(110)
        }
    }
}


