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
        }

        func configure(with article: NewsArticle) {
            titleLabel.text = article.title

            let source = article.source_id ?? "Source"
            let time = article.pubDate?.timeAgo() ?? ""
            subtitleLabel.text = "\(source) • \(time)"

            if let link = article.image_url, let url = URL(string: link) {
                newsImageView.kf.setImage(with: url)
            } else {
                newsImageView.image = UIImage(named: "placeholder")
            }
        }
}



