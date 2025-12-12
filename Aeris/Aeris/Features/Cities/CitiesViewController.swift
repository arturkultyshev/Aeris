//
//  CitiesViewController.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import UIKit

final class CitiesViewController: UIViewController {

    private let metricsContainerView = UIView()
    private let metricSegmentedControl = UISegmentedControl(items: AirQualityMetric.allCases.map { $0.title })
    private let tableView = UITableView(frame: .zero, style: .plain)
    

    var cities: [City] {
        CityStore.shared.cities
    }


    private var currentMetric: AirQualityMetric = .pm25 {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities"
        view.backgroundColor = UIColor.systemGray6

        setupMetricsHeader()
        setupTableView()

        metricSegmentedControl.selectedSegmentIndex = currentMetric.rawValue

        // Подписываемся на обновления стора
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCityStoreUpdate),
            name: .cityStoreDidUpdate,
            object: nil
        )

        // Стартуем загрузку метрик (один раз, но благодаря кэшу — ок)
        CityStore.shared.refreshAll()
    }

    private func setupMetricsHeader() {
        metricsContainerView.translatesAutoresizingMaskIntoConstraints = false
        metricsContainerView.backgroundColor = UIColor.systemGray6
        metricsContainerView.layer.cornerRadius = 24

        metricSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        metricSegmentedControl.selectedSegmentTintColor = .white
        metricSegmentedControl.backgroundColor = UIColor.systemGray6
        metricSegmentedControl.addTarget(self, action: #selector(metricChanged), for: .valueChanged)

        view.addSubview(metricsContainerView)
        metricsContainerView.addSubview(metricSegmentedControl)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            metricsContainerView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            metricsContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            metricsContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            metricsContainerView.heightAnchor.constraint(equalToConstant: 64),

            metricSegmentedControl.topAnchor.constraint(equalTo: metricsContainerView.topAnchor, constant: 8),
            metricSegmentedControl.bottomAnchor.constraint(equalTo: metricsContainerView.bottomAnchor, constant: -8),
            metricSegmentedControl.leadingAnchor.constraint(equalTo: metricsContainerView.leadingAnchor, constant: 8),
            metricSegmentedControl.trailingAnchor.constraint(equalTo: metricsContainerView.trailingAnchor, constant: -8)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 260
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseId)

        view.addSubview(tableView)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: metricsContainerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)   // <- главное изменение
        ])
    }


    

    @objc private func metricChanged() {
        guard let metric = AirQualityMetric(rawValue: metricSegmentedControl.selectedSegmentIndex) else { return }
        currentMetric = metric
    }
    
    @objc private func handleCityStoreUpdate() {
        tableView.reloadData()
    }

}


extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseId, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }

        let city = cities[indexPath.row]
        cell.configure(with: city, metric: currentMetric)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        guard let air = city.airQuality else { return }

        let detailVC = CityDetailViewController(city: city, airQuality: air, metric: currentMetric)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

