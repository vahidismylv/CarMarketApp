//
//  Chip.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 14.02.26.
//
import UIKit
import SnapKit

final class Chip: UIView {

    var icon: UIImage? {
        didSet { iconView.image = icon }
    }

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppColor.secondaryText
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 13, weight: .medium)
        lbl.textColor = AppColor.primaryText
        lbl.numberOfLines = 1
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        label.text = text
    }

    private func setupUI() {
        backgroundColor = AppColor.background
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = AppColor.stroke.cgColor

        addSubview(iconView)
        addSubview(label)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }

        label.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }

        snp.makeConstraints { make in
            make.height.equalTo(28)
        }
    }
}
