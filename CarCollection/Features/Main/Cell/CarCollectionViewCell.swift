//
//  CarCollectionViewCell.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 14.02.26.
//

import UIKit
import SnapKit


class CarCollectionViewCell: UICollectionViewCell {
    
    var onFavoriteTap: (() -> Void)?
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.card
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.stroke.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .medium)
        lbl.textColor = AppColor.primaryText
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let modelLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .medium)
        lbl.textColor = AppColor.secondaryText
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.textColor = AppColor.secondaryText
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let locationLabel: UILabel = {
        let txt = UILabel()
        txt.textColor = AppColor.accent
        txt.font = .systemFont(ofSize: 16,weight: .semibold)
        return txt
    }()
    
    
    private let transmissionType: Chip = {
        let lbl = Chip()
        lbl.icon = UIImage(systemName: "gearshape")
        return lbl
    }()
    
    private let fuelType: Chip = {
        let lbl = Chip()
        lbl.icon = UIImage(systemName: "fuelpump")
        return lbl
    }()
    
    private let bodyType: Chip = {
        let lbl = Chip()
        lbl.icon = UIImage(systemName: "car")
        return lbl
    }()
    
    private let priceTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Price:"
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    
    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .systemYellow
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.tintColor = AppColor.primaryText
        btn.backgroundColor = AppColor.card
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 3
        sv.distribution = .fillEqually
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.addSubview(containerView)
        [imageView, nameLabel,modelLabel,locationLabel, dateLabel,stackView,priceTextLabel,
         priceLabel, favoriteButton].forEach { containerView.addSubview($0) }
        
        stackView.addArrangedSubview(transmissionType)
        stackView.addArrangedSubview(fuelType)
        stackView.addArrangedSubview(bodyType)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(20)
        }
        
        modelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(9)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        
        priceTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stackView)
            make.trailing.equalToSuperview().inset(20)
        }
    
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTextLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(20)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
    }
    
    @objc private func didTapFavorite() {
        onFavoriteTap?()
    }
    
    func setFavorite(_ isFavorite: Bool) {
        let icon = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    func configure(date: String,
                   name: String,
                   model: String,
                   transmission: String,
                   fuel: String,
                   body: String,
                   location: String,
                   price: String,
                   image: UIImage?) {
        
        dateLabel.text = date
        nameLabel.text = name
        modelLabel.text = model
        
        transmissionType.setText(transmission)
        fuelType.setText(fuel)
        bodyType.setText(body)
        
        locationLabel.text = "📍 \(location)"
        
        priceLabel.text = price
        imageView.image = image
    }
}


