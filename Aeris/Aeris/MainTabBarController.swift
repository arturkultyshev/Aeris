//
//  MainTabBarController.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - 1. Cities
        let citiesVC = CitiesViewController()
        let citiesNav = UINavigationController(rootViewController: citiesVC)
        citiesNav.tabBarItem = UITabBarItem(
            title: "Cities",
            image: UIImage(systemName: "building.2"),
            tag: 0
        )

        // MARK: - 2. Trending
        let trendingVC = SimplePlaceholderViewController(
            titleText: "Trending",
            systemImageName: "chart.line.uptrend.xyaxis"
        )
        let trendingNav = UINavigationController(rootViewController: trendingVC)
        trendingNav.tabBarItem = UITabBarItem(
            title: "Trending",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            tag: 1
        )

        // MARK: - 3. News (НОВАЯ ВКЛАДКА)
        let newsStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newsVC = newsStoryboard.instantiateViewController(withIdentifier: "NewsVC") as! NewsListViewController
        let newsNav = UINavigationController(rootViewController: newsVC)
        newsNav.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            tag: 2
        )

        // MARK: - 4. Settings
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 3
        )

        // MARK: - Add Tabs
        viewControllers = [citiesNav, trendingNav, newsNav, settingsNav]
    }
}

/// Простой заглушочный экран
final class SimplePlaceholderViewController: UIViewController {

    private let titleText: String
    private let systemImageName: String

    init(titleText: String, systemImageName: String) {
        self.titleText = titleText
        self.systemImageName = systemImageName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = titleText

        let imageView = UIImageView(image: UIImage(systemName: systemImageName))
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
