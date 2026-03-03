//
//  GalleryImageCell.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 16.02.26.
//
import UIKit
import SnapKit

final class GalleryImageCell: UICollectionViewCell {

    static let reuseId = "GalleryImageCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColor.card
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }
}
