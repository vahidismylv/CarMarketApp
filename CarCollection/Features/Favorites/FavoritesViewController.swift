//
//  FavoritesViewController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 14.02.26.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {

    private let viewModel: FavoritesViewModel

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Favorites"
        lbl.textColor = AppColor.primaryText
        lbl.font = .systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()

    private let emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No favorites yet.\nOpen a car and tap the heart ❤️"
        lbl.textColor = AppColor.secondaryText
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background

        bindViewModel()
        setupViews()
        setupUI()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.loadFavorites()
    }


    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
    }

    private func setupUI() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CarCollectionViewCell.self, forCellWithReuseIdentifier: CarCollectionViewCell.identifier)
    }


    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            let isEmpty = self.viewModel.numberOfItems() == 0
            self.emptyLabel.isHidden = !isEmpty
            self.collectionView.isHidden = isEmpty
            self.collectionView.reloadData()
        }
    }
}


extension FavoritesViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                  let currentIndexPath = self.collectionView.indexPath(for: cell) else { return }

            self.viewModel.toggleFavorite(at: currentIndexPath.item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
}
