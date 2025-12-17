//
//  OnboardingPageViewController.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 06.12.2025.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    let pagesData: [(image: String, title: String, desc: String, button: String?)] = [
        ("onboard1", "Breath Better", "Understand the air around you, wherever you go with the largest coverage of trusted data.", "Primary"),
        ("onboard2", "Track Pollution", "Discover your personal exposure during your daily routine and take action to reduce it", "Get Started"),
        ("onboard3", "Control Exposure", "During your daily routine discover your personal exposure and take action", "Get Started")
    ]

    lazy var pages: [OnboardingContentViewController] = {
        var arr = [OnboardingContentViewController]()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        for item in pagesData {
            let vc = sb.instantiateViewController(withIdentifier: "OnboardingContentViewController") as! OnboardingContentViewController
            vc.imageName = item.image
            vc.titleText = item.title
            vc.descText = item.desc
            vc.buttonTitle = item.button
            arr.append(vc)
        }
        return arr
    }()

    private var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        for view in self.view.subviews {
                    if let scrollView = view as? UIScrollView {
                        scrollView.layer.speed = 5.0
                    }
                }
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }

        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120)
        ])

        let skip = UIButton(type: .system)
        skip.setTitle("Skip", for: .normal)
        skip.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skip)
        NSLayoutConstraint.activate([
            skip.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            skip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    @objc func skipTapped() {
        finishOnboarding()
    }
    func goToNextPage(from index: Int) {
        let nextIndex = index + 1
        if nextIndex < pages.count {
            let nextVC = pages[nextIndex]
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = nextIndex
        } else {
            finishOnboarding()
        }
    }


    func finishOnboarding() {
        let tabBar = MainTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true, completion: nil)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pvc: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController as! OnboardingContentViewController) else { return nil }
        let prev = idx - 1
        guard prev >= 0 else { return nil }
        return pages[prev]
    }
    
    func pageViewController(_ pvc: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let idx = pages.firstIndex(of: viewController as! OnboardingContentViewController) else { return nil }
        let next = idx + 1
        guard next < pages.count else { return nil }
        return pages[next]
    }
    
    func pageViewController(_ pvc: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let current = viewControllers?.first as? OnboardingContentViewController,
           let idx = pages.firstIndex(of: current) {
            pageControl.currentPage = idx
        }
    }
}

