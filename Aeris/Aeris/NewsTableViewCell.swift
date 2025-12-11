//
//  NewsTableViewCell.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import UIKit
import Kingfisher

final class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        newsImageView.layer.borderWidth = 1
        newsImageView.layer.borderColor = UIColor.lightGray.cgColor
        newsImageView.layer.masksToBounds = true

    }

    func configure(with article: NewsArticle) {
        titleLabel.text = article.title
        subtitleLabel.text = "By \(article.source_id ?? "Unknown") • \(article.pubDate ?? "")"

        if let urlString = article.image_url,
           let url = URL(string: urlString) {
            newsImageView.kf.setImage(with: url)
        } else {
            newsImageView.image = UIImage(named: "placeholder")
        }
    }
}



