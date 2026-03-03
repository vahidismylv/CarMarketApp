//
//  MainViewController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 13.02.26.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

    private let viewModel: MainViewModel
    
    private let topLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AutoMarket"
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .bold)
        return lbl
    }()
    
    private let subLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Find your car"
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 18, weight: .regular)
        return lbl
    }()
    
    private let filterButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        btn.backgroundColor = AppColor.card
        btn.tintColor = AppColor.primaryText
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    private let searchBar: SearchBar = {
        let icon = UIImage(systemName: "magnifyingglass")
        return SearchBar(icon: icon, placeholder: "Search")
    }()
    
    private let carCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        return view
    }()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupViews()
        setupUI()
        setupCollectionView()
        bindViewModel()

        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        searchCar()
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.backgroundEffect = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        if let text = searchBar.textField.text, !text.isEmpty {
            viewModel.applySearch(text)
        } else {
            viewModel.setFilters(viewModel.activeFilters)
        }
    }
    
    private func setupViews() {
        [topLabel,subLabel,filterButton,searchBar, carCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupUI() {
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(24)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(24)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(85)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(50)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        carCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        carCollectionView.delegate = self
        carCollectionView.dataSource = self
        carCollectionView.register(CarCollectionViewCell.self, forCellWithReuseIdentifier: CarCollectionViewCell.identifier)
    }
    
    private func searchCar() {
        searchBar.onTextChanged = { [weak self] text in
            self?.viewModel.applySearch(text)
        }
    }

    @objc private func didTapFilter() {
        let vc = FilterViewController(currentFilters: viewModel.activeFilters)

        vc.onApply = { [weak self] result in
            guard let self else { return }
            self.searchBar.textField.text = ""
            self.viewModel.setFilters(result)
        }

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 28
        }

        present(nav, animated: true)
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.carCollectionView.reloadData()
        }
    }
}


extension MainViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CarCollectionViewCell.identifier,
            for: indexPath
        ) as! CarCollectionViewCell
        
        let car = viewModel.item(at: indexPath.item)

        cell.configure(
            date: car.date,
            name: car.name,
            model: car.model,
            transmission: car.transmission,
            fuel: car.fuelType,
            body: car.bodyType,
            location: car.location,
            price: car.price,
            image: UIImage(named: car.imageName)
        )
        
        cell.setFavorite(viewModel.isFavorite(at: indexPath.item))
        
        cell.onFavoriteTap = { [weak self, weak cell] in
            guard let self,
                  let cell,
                  let currentIndexPath = self.carCollectionView.indexPath(for: cell) else { return }

            self.viewModel.toggleFavorite(at: currentIndexPath.item)
            self.carCollectionView.reloadItems(at: [currentIndexPath])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        guard let detailViewModel = viewModel.detailViewModel(at: indexPath.item) else { return }
        let vc = CarDetailViewController(viewModel: detailViewModel)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 40
        return CGSize(width: width, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
}


