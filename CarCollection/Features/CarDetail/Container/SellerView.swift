//
//  SellerView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 18.02.26.
//

import UIKit
import SnapKit

final class SellerCardView: UIView {

    private let avatarView = UIView()
    private let nameLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppColor.card
        layer.cornerRadius = 18
        clipsToBounds = true

        avatarView.backgroundColor = AppColor.accent
        avatarView.layer.cornerRadius = 25
        avatarView.clipsToBounds = true

        nameLabel.textColor = AppColor.primaryText
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        arrowImageView.tintColor = AppColor.secondaryText
        arrowImageView.contentMode = .scaleAspectFit

        addSubview(avatarView)
        addSubview(nameLabel)
        addSubview(arrowImageView)

        avatarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(avatarView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualTo(arrowImageView.snp.leading).offset(-12)
        }

        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    func configure(seller: Seller) {
        nameLabel.text = seller.name
    }

    func configure(name: String, info: String) {
        nameLabel.text = name
    }
}

