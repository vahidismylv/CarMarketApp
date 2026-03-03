//
//  FilterBottomBarView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 23.02.26.
//
import UIKit
import SnapKit

final class FilterBottomBarView: UIView {

    var onReset: (() -> Void)?
    var onApply: (() -> Void)?

    private let stack: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 12
        st.distribution = .fillEqually
        return st
    }()

    private let resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Reset", for: .normal)
        btn.setTitleColor(AppColor.primaryText, for: .normal)
        btn.backgroundColor = AppColor.card
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColor.stroke.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()

    private let applyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Apply", for: .normal)
        btn.setTitleColor(AppColor.background, for: .normal)
        btn.backgroundColor = AppColor.primaryText
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = AppColor.background

        addSubview(stack)
        stack.addArrangedSubview(resetButton)
        stack.addArrangedSubview(applyButton)

        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(52)
        }

        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(didTapApply), for: .touchUpInside)
    }

    @objc private func didTapReset() {
        onReset?()
    }

    @objc private func didTapApply() {
        onApply?()
    }
}
