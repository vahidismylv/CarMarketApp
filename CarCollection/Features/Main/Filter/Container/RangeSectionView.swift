//
//  RangeSectionView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 23.02.26.
//
import UIKit
import SnapKit

final class RangeSectionView: UIView {

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        return lbl
    }()

    private let stack: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()

    private let minField = FilterViewController.makeNumberField(placeholder: "From")
    private let maxField = FilterViewController.makeNumberField(placeholder: "To")

    var minText: String { (minField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines) }
    var maxText: String { (maxField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines) }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(stack)

        stack.addArrangedSubview(minField)
        stack.addArrangedSubview(maxField)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func set(min: Int?, max: Int?) {
        minField.text = min.map(String.init)
        maxField.text = max.map(String.init)
    }

    func clear() {
        minField.text = nil
        maxField.text = nil
    }
}
