//
//  FilterViewController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 21.02.26.
//

import UIKit
import SnapKit

final class FilterViewController: UIViewController {

    var onApply: ((FiltersResult) -> Void)?
    private let initialFilters: FiltersResult?

    init(currentFilters: FiltersResult?) {
        self.initialFilters = currentFilters
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView = UIView()

    private let contentStack: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 30
        return st
    }()

    private let priceSection = RangeSectionView(title: "Price (USD $)")
    private let yearSection = RangeSectionView(title: "Year")
    private let mileageSection = RangeSectionView(title: "Mileage")

    private let bodyTypeSection = ChipsSectionView(
        title: "Body type",
        chips: ["Sedan", "SUV", "Coupe", "Hatchback", "Pickup"]
    )
    
    private let fuelTypeSection = ChipsSectionView(
        title: "Fuel type",
        chips: ["Petrol", "Diesel", "Electric","Hybrid"]
    )
    
    private let transmissionTypeSection = ChipsSectionView (
        title: "Transmission type",
        chips: ["AWD","FWD","RWD","DCT","AMT"]
    )

    private let bottomBar = FilterBottomBarView()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        setupNavBarAppearance()
        setupNavigationBar()

        setupViews()
        setupLayout()
        setupActions()
        applyInitialStateIfNeeded()
    }

    private func applyInitialStateIfNeeded() {
        guard let f = initialFilters else { return }

        priceSection.set(min: f.minPrice, max: f.maxPrice)
        yearSection.set(min: f.minYear, max: f.maxYear)
        mileageSection.set(min: f.minMileage, max: f.maxMileage)

        bodyTypeSection.setSelected(titles: f.bodyTypes)
        fuelTypeSection.setSelected(titles: f.fuelTypes)
        transmissionTypeSection.setSelected(titles: f.transmissions)
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStack)

        contentStack.addArrangedSubview(priceSection)
        contentStack.addArrangedSubview(yearSection)
        contentStack.addArrangedSubview(mileageSection)
        contentStack.addArrangedSubview(bodyTypeSection)
        contentStack.addArrangedSubview(fuelTypeSection)
        contentStack.addArrangedSubview(transmissionTypeSection)

        view.addSubview(bottomBar)
    }

    private func setupLayout() {
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    private func setupActions() {
        bottomBar.onReset = { [weak self] in
            self?.resetAll()
        }

        bottomBar.onApply = { [weak self] in
            self?.applyAndClose()
        }
    }


    private func resetAll() {
        priceSection.clear()
        yearSection.clear()
        mileageSection.clear()
        bodyTypeSection.reset()
        fuelTypeSection.reset()
        transmissionTypeSection.reset()
    }

    private func applyAndClose() {
        let result = FiltersResult(
            minPrice: Int(priceSection.minText),
            maxPrice: Int(priceSection.maxText),
            minYear: Int(yearSection.minText),
            maxYear: Int(yearSection.maxText),
            minMileage: Int(mileageSection.minText),
            maxMileage: Int(mileageSection.maxText),
            bodyTypes: bodyTypeSection.selectedTitles,
            fuelTypes: fuelTypeSection.selectedTitles,
            transmissions: transmissionTypeSection.selectedTitles
        )

        onApply?(result)
        dismiss(animated: true)
    }


    private func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.background
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: AppColor.primaryText,
            .font: UIFont.systemFont(ofSize: 25, weight: .bold)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = AppColor.primaryText
        navigationController?.navigationBar.isTranslucent = false
    }

    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Filter"

        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.backgroundColor = AppColor.card
        btn.tintColor = AppColor.primaryText
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 40),
            btn.heightAnchor.constraint(equalToConstant: 40)
        ])

        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }


    static func makeNumberField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: AppColor.secondaryText,
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
        )
        tf.textColor = AppColor.primaryText
        tf.keyboardType = .numberPad
        tf.backgroundColor = AppColor.card
        tf.layer.cornerRadius = 14
        tf.layer.borderWidth = 1
        tf.layer.borderColor = AppColor.stroke.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        return tf
    }
}


