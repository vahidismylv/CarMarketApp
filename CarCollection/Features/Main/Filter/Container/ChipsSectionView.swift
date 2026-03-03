//
//  ChipsSectionView.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 23.02.26.
//
import UIKit
import SnapKit

final class ChipsSectionView: UIView {

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        return lbl
    }()

    private let row1: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()

    private let row2: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()

    private var selected: Set<String> = []
    private var buttons: [UIButton] = []

    var selectedTitles: [String] {
        buttons.compactMap { btn in
            let title = btn.title(for: .normal) ?? ""
            return selected.contains(title) ? title : nil
        }
    }

    init(title: String, chips: [String]) {
        super.init(frame: .zero)
        titleLabel.text = title
        buttons = chips.map { makeChip(title: $0) }
        setup()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(row1)
        addSubview(row2)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        row1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        row2.snp.makeConstraints { make in
            make.top.equalTo(row1.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(30)
        }

        for (idx, btn) in buttons.enumerated() {
            if idx < 3 {
                row1.addArrangedSubview(btn)
            } else if idx < 6 {
                row2.addArrangedSubview(btn)
            }
        }

        while row1.arrangedSubviews.count < 3 {
            row1.addArrangedSubview(UIView())
        }
        while row2.arrangedSubviews.count < 3 {
            row2.addArrangedSubview(UIView())
        }
    }

    private func makeChip(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(AppColor.primaryText, for: .normal)
        btn.backgroundColor = AppColor.card
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 1
        btn.layer.borderColor = AppColor.stroke.cgColor
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.addTarget(self, action: #selector(didTapChip(_:)), for: .touchUpInside)
        return btn
    }

    @objc private func didTapChip(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if selected.contains(title) {
            selected.remove(title)
        } else {
            selected.insert(title)
        }

        updateUI()
    }
    

    private func updateUI() {
        for btn in buttons {
            let title = btn.title(for: .normal) ?? ""
            let isSelected = selected.contains(title)

            if isSelected {
                btn.backgroundColor = AppColor.primaryText
                btn.setTitleColor(AppColor.background, for: .normal)
                btn.layer.borderColor = AppColor.primaryText.cgColor
            } else {
                btn.backgroundColor = AppColor.card
                btn.setTitleColor(AppColor.primaryText, for: .normal)
                btn.layer.borderColor = AppColor.stroke.cgColor
            }
        }
    }
    
    func setSelected(titles: [String]) {
        selected = Set(titles)
        updateUI()
    }

    func reset() {
        selected.removeAll()
        updateUI()
    }
}
