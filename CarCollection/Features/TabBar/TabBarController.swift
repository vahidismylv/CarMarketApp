//
//  TabBarController.swift
//  CarCollection
//
//  Created by Vahid Ismayilov on 13.02.26.
//

import UIKit

class TabBarController: UITabBarController {

    private let dependencies: AppDependencyContainer

    init(dependencies: AppDependencyContainer) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupTabBar()
        setupTabBarConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var tabBarFrame = tabBar.frame
        tabBarFrame.size.height = 100
        tabBarFrame.origin.y = view.frame.height - 90
        tabBar.frame = tabBarFrame
    }

    
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: MainViewController(viewModel: dependencies.makeMainViewModel()))
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
        homeVC.tabBarItem.tag = 0
        
        let favoriteVC = UINavigationController(rootViewController: FavoritesViewController(viewModel: dependencies.makeFavoritesViewModel()))
        favoriteVC.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill"))
        favoriteVC.tabBarItem.tag = 1
        
        let profileVC = UINavigationController(
            rootViewController: ProfileViewController(
                viewModel: dependencies.makeProfileViewModel(),
                makeLoginViewController: { [dependencies] in
                    LoginViewController(viewModel: dependencies.makeLoginViewModel())
                }
            )
        )
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"))
        profileVC.tabBarItem.tag = 2
        
        viewControllers = [homeVC, favoriteVC, profileVC]
    }
    
    private func setupTabBarConstraints() {
        tabBar.frame.size.height = 90
        
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = false
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 10
                
        tabBar.backgroundColor = AppColor.card
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
            
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
    }
}
