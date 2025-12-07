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
    

    private var cities: [City] = [
        City(
            name: "ALMATY",
            apiCity: "Almaty",
            state: "Almaty Oblysy",
            country: "Kazakhstan",
            imageName: "almaty",         // добавь такие картинки в Assets
            subtitle: "sensitive groups should limit outdoor activity"
        ),
        City(
            name: "ASTANA",
            apiCity: "Astana",
            state: "Astana",
            country: "Kazakhstan",
            imageName: "astana",
            subtitle: "sensitive groups should limit outdoor activity"
        ),
        City(
            name: "AQTOBE",
            apiCity: "Aqtobe",
            state: "Aqtoebe",
            country: "Kazakhstan",
            imageName: "aqtobe",
            subtitle: "mask recommended"
        )
    ]

    private var currentMetric: AirQualityMetric = .pm25 {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6

        setupMetricsHeader()
        setupTableView()
        

        metricSegmentedControl.selectedSegmentIndex = currentMetric.rawValue

        loadData()
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

    private func loadData() {
        for (index, city) in cities.enumerated() {
            AirQualityService.shared.fetchAirQuality(for: city) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.cities[index].airQuality = data
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                case .failure:
                    // В учебном проекте тихо игнорируем
                    break
                }
            }
        }
    }
}

// MARK: - Table delegate/data source

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

