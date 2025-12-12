//
//  TrendingViewController.swift
//  Aeris
//
//  Created by Артур Култышев on 12.12.2025.
//

import UIKit

final class TrendingViewController: UIViewController {

    // MARK: - UI

    private let metricsContainerView = UIView()
    private let metricSegmentedControl =
        UISegmentedControl(items: AirQualityMetric.allCases.map { $0.title })

    private let spotlightLabel = UILabel()

    private let bestCityButton = UIButton(type: .system)
    private let worstCityButton = UIButton(type: .system)

    private let modeSegmentedControl =
        UISegmentedControl(items: ["Best Air", "Worst Air"])

    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - State

    private var currentMetric: AirQualityMetric = .pm25
    private var showBest: Bool = true

    /// Отсортированные города для таблицы
    private var sortedCities: [City] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trending"
        view.backgroundColor = .systemGray6

        setupMetricsHeader()
        setupSpotlight()
        setupModeControl()
        setupTableView()

        // выбранная метрика
        metricSegmentedControl.selectedSegmentIndex = currentMetric.rawValue
        modeSegmentedControl.selectedSegmentIndex = 0

        // слушаем обновления от CityStore
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCityStoreUpdate),
            name: .cityStoreDidUpdate,
            object: nil
        )

        // запрашиваем данные (AirQualityService сам использует кэш)
        CityStore.shared.refreshAll()

        reloadFromStore()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup UI

    private func setupMetricsHeader() {
        metricsContainerView.translatesAutoresizingMaskIntoConstraints = false
        metricsContainerView.backgroundColor = .systemGray6
        metricsContainerView.layer.cornerRadius = 24

        metricSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        metricSegmentedControl.selectedSegmentTintColor = .white
        metricSegmentedControl.backgroundColor = .systemGray6
        metricSegmentedControl.addTarget(self,
                                         action: #selector(metricChanged),
                                         for: .valueChanged)

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

    private func setupSpotlight() {
        spotlightLabel.translatesAutoresizingMaskIntoConstraints = false
        spotlightLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        spotlightLabel.text = "Spotlight"

        configureSpotlightButton(bestCityButton)
        configureSpotlightButton(worstCityButton)

        bestCityButton.setTitle("Best city", for: .normal)
        worstCityButton.setTitle("Worst city", for: .normal)

        view.addSubview(spotlightLabel)
        view.addSubview(bestCityButton)
        view.addSubview(worstCityButton)

        NSLayoutConstraint.activate([
            spotlightLabel.topAnchor.constraint(equalTo: metricsContainerView.bottomAnchor, constant: 16),
            spotlightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            bestCityButton.topAnchor.constraint(equalTo: spotlightLabel.bottomAnchor, constant: 8),
            bestCityButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestCityButton.heightAnchor.constraint(equalToConstant: 44),

            worstCityButton.topAnchor.constraint(equalTo: spotlightLabel.bottomAnchor, constant: 8),
            worstCityButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            worstCityButton.heightAnchor.constraint(equalToConstant: 44),
            worstCityButton.leadingAnchor.constraint(equalTo: bestCityButton.trailingAnchor, constant: 16),
            bestCityButton.widthAnchor.constraint(equalTo: worstCityButton.widthAnchor)
        ])
    }

    private func configureSpotlightButton(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.isUserInteractionEnabled = false   // это просто отображение
    }

    private func setupModeControl() {
        modeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        modeSegmentedControl.selectedSegmentTintColor = .white
        modeSegmentedControl.backgroundColor = .systemGray5
        modeSegmentedControl.addTarget(self,
                                       action: #selector(modeChanged),
                                       for: .valueChanged)

        view.addSubview(modeSegmentedControl)

        NSLayoutConstraint.activate([
            modeSegmentedControl.topAnchor.constraint(equalTo: bestCityButton.bottomAnchor, constant: 12),
            modeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            modeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            modeSegmentedControl.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 260
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self,
                           forCellReuseIdentifier: CityTableViewCell.reuseId)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: modeSegmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Data

    @objc private func handleCityStoreUpdate() {
        reloadFromStore()
    }

    private func reloadFromStore() {
        let all = CityStore.shared.cities

        // берём только те, у кого уже есть данные
        let withData: [(City, Int)] = all.compactMap { city in
            guard let aq = city.airQuality else { return nil }
            return (city, aq.value(for: currentMetric))
        }

        guard !withData.isEmpty else {
            sortedCities = []
            updateSpotlight(best: nil, worst: nil)
            tableView.reloadData()
            return
        }

        // сортировка по возрастанию AQI
        let sortedAsc = withData.sorted { $0.1 < $1.1 }
        let best = sortedAsc.first
        let worst = sortedAsc.last

        let final: [City]
        if showBest {
            final = sortedAsc.map { $0.0 }
        } else {
            final = sortedAsc.reversed().map { $0.0 }
        }

        sortedCities = final
        updateSpotlight(best: best, worst: worst)
        tableView.reloadData()
    }

    private func updateSpotlight(best: (City, Int)?, worst: (City, Int)?) {
        if let best = best {
            bestCityButton.setTitle("✅ \(best.0.name)  •  \(best.1)", for: .normal)
        } else {
            bestCityButton.setTitle("Best city – loading…", for: .normal)
        }

        if let worst = worst {
            worstCityButton.setTitle("⚠️ \(worst.0.name)  •  \(worst.1)", for: .normal)
        } else {
            worstCityButton.setTitle("Worst city – loading…", for: .normal)
        }
    }

    // MARK: - Actions

    @objc private func metricChanged() {
        guard let metric = AirQualityMetric(rawValue: metricSegmentedControl.selectedSegmentIndex) else { return }
        currentMetric = metric
        reloadFromStore()
    }

    @objc private func modeChanged() {
        showBest = (modeSegmentedControl.selectedSegmentIndex == 0)
        reloadFromStore()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension TrendingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sortedCities.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityTableViewCell.reuseId,
            for: indexPath
        ) as? CityTableViewCell else {
            return UITableViewCell()
        }

        let city = sortedCities[indexPath.row]
        cell.configure(with: city, metric: currentMetric)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let city = sortedCities[indexPath.row]
        guard let air = city.airQuality else { return }

        let detailVC = CityDetailViewController(
            city: city,
            airQuality: air,
            metric: currentMetric
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
