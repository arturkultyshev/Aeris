//
//  OnboardingContentViewController.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 06.12.2025.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    
    var imageName: String?
    var titleText: String?
    var descText: String?
    var buttonTitle: String?
    
    private var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupStyles()
        animateAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = primaryButton.bounds
    }

    @IBAction func primaryButtonTapped(_ sender: UIButton) {
        if let pvc = parent as? OnboardingPageViewController,
           let index = pvc.pages.firstIndex(of: self) {
            pvc.goToNextPage(from: index)
        }
    }
}

private extension OnboardingContentViewController {
    
    func setupContent() {
        imageView.image = UIImage(named: imageName ?? "")
        titleLabel.text = titleText
        descLabel.text = descText
        primaryButton.setTitle(buttonTitle, for: .normal)
    }
    
    func setupStyles() {
        titleLabel.textAlignment = .center
        descLabel.textAlignment = .center
        
        titleLabel.numberOfLines = 0
        descLabel.numberOfLines = 0

        
        primaryButton.layer.cornerRadius = 8
        primaryButton.clipsToBounds = true
        
        gradientLayer.colors = [
            UIColor(red: 0.11, green: 0.53, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.06, green: 0.45, blue: 0.95, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 16
        
        primaryButton.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func animateAppearance() {
        view.alpha = 0
        UIView.animate(withDuration: 1.35, animations: {
            self.view.alpha = 1
        })
    }
}
