//
//  NewsListViewController.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 11.12.2025.
//

import UIKit
import  Foundation

final class NewsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var articles: [NewsArticle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchNews()
    }

    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    private func fetchNews() {
        NewsAPIService.shared.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    print("Loaded articles:", list.count)

                    let filtered = list.filter { $0.title != nil }

                    self?.articles = filtered
                    self?.tableView.reloadData()

                case .failure(let error):
                    print("News error:", error)
                }
            }
        }
    }



}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        
        detailVC.article = article
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

