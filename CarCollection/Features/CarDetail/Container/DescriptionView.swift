//
//  DescriptionView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 18.02.26.
//

import UIKit
import SnapKit

class DescriptionView: UIView {
    private let textLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(20)
        }
            
        
    }
    
    func configure(with text: String) {
        textLabel.text = text
    }
    
}
