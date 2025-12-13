//
//  NewsDetailViewController.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import UIKit
import Kingfisher

final class NewsDetailViewController: UIViewController {

    var article: NewsArticle?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!

    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }

        private func setupUI() {
            guard let article else { return }

            titleLabel.text = article.title
            descriptionLabel.text = article.description ?? "This article explores current air quality and environmental conditions."

            if let link = article.image_url, let url = URL(string: link) {
                imageView.kf.setImage(with: url)
            }

            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            readMoreButton.layer.cornerRadius = 10
        }

        @IBAction func readMoreTapped(_ sender: UIButton) {
            guard let link = article?.link,
                  let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }
}

