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

    private var currentMetric: AirQualityMetric = SettingsManager.shared.defaultMetric {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities"
        view.backgroundColor = .systemGray6

        setupMetricsHeader()
        setupTableView()

        currentMetric = SettingsManager.shared.defaultMetric
        metricSegmentedControl.selectedSegmentIndex = currentMetric.rawValue

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(defaultMetricDidChange),
            name: .didChangeDefaultMetric,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCityStoreUpdate),
            name: .cityStoreDidUpdate,
            object: nil
        )

        CityStore.shared.refreshAll()
    }

    @objc private func defaultMetricDidChange() {
        let metric = SettingsManager.shared.defaultMetric
        currentMetric = metric
        metricSegmentedControl.selectedSegmentIndex = metric.rawValue
    }

    private func setupMetricsHeader() {
        metricsContainerView.translatesAutoresizingMaskIntoConstraints = false
        metricsContainerView.layer.cornerRadius = 24
        metricsContainerView.backgroundColor = .systemGray6

        metricSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
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
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
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
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseId, for: indexPath) as! CityTableViewCell
        cell.configure(with: cities[indexPath.row], metric: currentMetric)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let city = cities[indexPath.row]
            guard let air = city.airQuality else { return }

            let detailVC = CityDetailViewController(city: city, airQuality: air, metric: currentMetric)
            navigationController?.pushViewController(detailVC, animated: true)
        }
}
