//
//  CarDetailViewController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 16.02.26.
//

import UIKit
import SnapKit

final class CarDetailViewController: UIViewController {

    private let viewModel: CarDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let galleryContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.clipsToBounds = true
        return v
    }()

    private lazy var galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = AppColor.background
        cv.dataSource = self
        cv.delegate = self
        cv.register(GalleryImageCell.self, forCellWithReuseIdentifier: GalleryImageCell.reuseId)
        return cv
    }()


    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = AppColor.primaryText
        lbl.numberOfLines = 2
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        lbl.textColor = AppColor.secondaryText
        lbl.numberOfLines = 1
        return lbl
    }()

    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = AppColor.accent
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let priceTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Price:"
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        lbl.textColor = AppColor.secondaryText
        return lbl
    }()

    private let priceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 26, weight: .bold)
        lbl.textColor = .systemYellow
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let quickSpecsStack: UIStackView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.alignment = .fill
        st.distribution = .fillEqually
        st.spacing = 12
        return st
    }()

    private let specsTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Technical Specifications"
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = AppColor.primaryText
        return lbl
    }()

    private let specsContainer: UIView = {
        let v = UIView()
        v.backgroundColor = AppColor.card
        v.layer.cornerRadius = 18
        v.clipsToBounds = true
        return v
    }()

    private let specsStack: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.alignment = .fill
        st.distribution = .fill
        st.spacing = 0
        return st
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Description"
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    private let descriptionView = DescriptionView()

    private let sellerTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Seller"
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()

    private let sellerCardView = SellerCardView()

    private let bottomBar: UIView = {
        let v = UIView()
        v.backgroundColor = AppColor.background
        return v
    }()

    private let callButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Call", for: .normal)
        btn.setTitleColor(AppColor.primaryText, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()

    init(viewModel: CarDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        bindViewModel()
        setupNavigationBar()
        setupViews()
        setupUI()
        fill()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = galleryCollectionView.bounds.size
        }
        
        let inset = 76 + 12
        if scrollView.contentInset.bottom != CGFloat(inset) {
            scrollView.contentInset.bottom = CGFloat(inset)
            scrollView.verticalScrollIndicatorInsets.bottom = CGFloat(inset)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .none
        appearance.shadowColor = .none
        appearance.backgroundEffect = .none

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
     
        navigationController?.navigationBar.tintColor = AppColor.primaryText
        
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    
    private func setupViews() {
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true

        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        view.addSubview(bottomBar)
        bottomBar.addSubview(callButton)

        callButton.addTarget(self, action: #selector(didTapCall), for: .touchUpInside)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(galleryContainer)
        galleryContainer.addSubview(galleryCollectionView)

        [titleLabel, subtitleLabel, locationLabel, priceTextLabel, priceLabel,
         quickSpecsStack, specsTitleLabel, specsContainer,
         descriptionTitleLabel, descriptionView,
         sellerTitleLabel, sellerCardView].forEach {
            contentView.addSubview($0)
        }
        
        specsContainer.addSubview(specsStack)
    }

    private func bindViewModel() {
        viewModel.onFavoriteChanged = { [weak self] _ in
            self?.setupNavigationBar()
        }
    }


    private func setupUI() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        galleryContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        galleryCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(galleryContainer.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(locationLabel.snp.leading).offset(-12)
        }

        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        
        priceTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTextLabel.snp.bottom).offset(6)
            make.leading.equalTo(priceTextLabel)
        }
        
        quickSpecsStack.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(86)
        }

        specsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(quickSpecsStack.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        specsContainer.snp.makeConstraints { make in
            make.top.equalTo(specsTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        specsStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(14)
        }
        
        descriptionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(specsContainer.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview().inset(22)
        }

        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        sellerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        sellerCardView.snp.makeConstraints { make in
            make.top.equalTo(sellerTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(90)
            make.bottom.equalToSuperview().inset(24)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(90)
        }

        callButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }

    private func fill() {
        titleLabel.text = viewModel.car.name
        subtitleLabel.text = viewModel.car.model
        locationLabel.text = viewModel.formattedLocation
        priceLabel.text = viewModel.car.price
        
        quickSpecsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        viewModel.quickStats.forEach { iconName, value, title in
            quickSpecsStack.addArrangedSubview(QuickStatView(iconName: iconName, value: value, title: title))
        }

        specsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, item) in viewModel.specs.enumerated() {
            let row = SpecRowView(title: item.0, value: item.1)
            specsStack.addArrangedSubview(row)

            if index != viewModel.specs.count - 1 {
                let separator = UIView()
                separator.backgroundColor = AppColor.stroke
                separator.alpha = 0.6
                separator.snp.makeConstraints { make in
                    make.height.equalTo(1)
                }
                specsStack.addArrangedSubview(separator)
            }
        }

        descriptionView.configure(with: viewModel.car.description)
        sellerCardView.configure(seller: viewModel.car.seller)
        
        galleryCollectionView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let back = UIBarButtonItem(customView: makeNavButton(imageName: "chevron.left",action: #selector(didTapBack)))
        
        let favIcon = viewModel.isFavorite ? "heart.fill" : "heart"
        let fav = UIBarButtonItem(customView: makeNavButton(imageName: favIcon,action: #selector(didTapFavorite)))
        
        navigationItem.leftBarButtonItem = back
        navigationItem.rightBarButtonItem = fav
    }
    
    @objc private func didTapCall() {
        let phone = viewModel.car.seller.phone

        let sheet = UIAlertController(title: "Contact seller", message: phone, preferredStyle: .actionSheet)

        sheet.addAction(UIAlertAction(title: "Call", style: .default, handler: { _ in
            guard let url = self.viewModel.contactPhoneURL(),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }))

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let pop = sheet.popoverPresentationController {
            pop.sourceView = callButton
            pop.sourceRect = callButton.bounds
        }

        present(sheet, animated: true)
    }
    
    private func makeNavButton(imageName: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: imageName), for: .normal)
        btn.backgroundColor = AppColor.card.withAlphaComponent(1.0)
        btn.tintColor = AppColor.primaryText
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 40),
            btn.heightAnchor.constraint(equalToConstant: 40)
        ])

        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.addTarget(self, action: action, for: .touchUpInside)
        
        return btn
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapFavorite() {
        viewModel.toggleFavorite()
    }
    
    
}


extension CarDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imageNames.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryImageCell.reuseId,
            for: indexPath
        ) as! GalleryImageCell

        let name = viewModel.imageNames[indexPath.item]
        cell.configure(image: UIImage(named: name))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

}

