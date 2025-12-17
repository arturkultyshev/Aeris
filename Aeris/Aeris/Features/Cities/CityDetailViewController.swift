//
//  CityDetailViewController.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import UIKit

final class CityDetailViewController: UIViewController {

    private let city: City
    private let airQuality: AirQualityData
    private var currentMetric: AirQualityMetric


    private let metricsContainerView = UIView()
    private let metricSegmentedControl = UISegmentedControl(items: AirQualityMetric.allCases.map { $0.title })

    private let bigCardView = UIView()
    private let bigValueLabel = UILabel()
    private let bigStatusLabel = UILabel()
    private let bigDescriptionLabel = UILabel()

    private let metricsBlockView = UIView()
    private let adviceCardView = UIView()
    private let adviceTitleLabel = UILabel()
    private let adviceTextLabel = UILabel()
    
    private lazy var backButton: UIButton = {
            let button = UIButton(type: .system)

            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.image = UIImage(systemName: "chevron.backward")
                config.title = "Cities"
                config.imagePadding = 4
                config.baseForegroundColor = .black
                button.configuration = config
            } else {
                button.setTitle("◀︎ Cities", for: .normal)
                button.setTitleColor(.black, for: .normal)
            }

            button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()


    init(city: City, airQuality: AirQualityData, metric: AirQualityMetric) {
        self.city = city
        self.airQuality = airQuality
        self.currentMetric = metric
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        navigationController?.isNavigationBarHidden = true

        setupMetricsHeader()
        setupBigCard()
        setupMetricsBlock()
        setupAdviceCard()
        setupBackButton()

        metricSegmentedControl.selectedSegmentIndex = currentMetric.rawValue
        updateBigCard()
        updateMetricsBlock()
        updateAdvice()
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
            metricsContainerView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 56),
            metricsContainerView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            metricsContainerView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            metricsContainerView.heightAnchor.constraint(equalToConstant: 64),

            metricSegmentedControl.topAnchor.constraint(equalTo: metricsContainerView.topAnchor, constant: 8),
            metricSegmentedControl.bottomAnchor.constraint(equalTo: metricsContainerView.bottomAnchor, constant: -8),
            metricSegmentedControl.leadingAnchor.constraint(equalTo: metricsContainerView.leadingAnchor, constant: 8),
            metricSegmentedControl.trailingAnchor.constraint(equalTo: metricsContainerView.trailingAnchor, constant: -8)
        ])
    }

    private func setupBigCard() {
        bigCardView.translatesAutoresizingMaskIntoConstraints = false
        bigCardView.layer.cornerRadius = 24
        bigCardView.layer.masksToBounds = true

        bigValueLabel.translatesAutoresizingMaskIntoConstraints = false
        bigValueLabel.font = UIFont.boldSystemFont(ofSize: 60)
        bigValueLabel.textAlignment = .center
        bigValueLabel.textColor = .white

        bigStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        bigStatusLabel.font = UIFont.systemFont(ofSize: 20)
        bigStatusLabel.textAlignment = .center
        bigStatusLabel.textColor = .white

        bigDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bigDescriptionLabel.font = UIFont.systemFont(ofSize: 14)
        bigDescriptionLabel.textAlignment = .center
        bigDescriptionLabel.textColor = .white
        bigDescriptionLabel.numberOfLines = 2

        view.addSubview(bigCardView)
        bigCardView.addSubview(bigValueLabel)
        bigCardView.addSubview(bigStatusLabel)
        bigCardView.addSubview(bigDescriptionLabel)

        NSLayoutConstraint.activate([
            bigCardView.topAnchor.constraint(equalTo: metricsContainerView.bottomAnchor, constant: 16),
            bigCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bigCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bigCardView.heightAnchor.constraint(equalToConstant: 200),

            bigValueLabel.centerXAnchor.constraint(equalTo: bigCardView.centerXAnchor),
            bigValueLabel.topAnchor.constraint(equalTo: bigCardView.topAnchor, constant: 40),

            bigStatusLabel.topAnchor.constraint(equalTo: bigValueLabel.bottomAnchor, constant: 8),
            bigStatusLabel.centerXAnchor.constraint(equalTo: bigCardView.centerXAnchor),

            bigDescriptionLabel.topAnchor.constraint(equalTo: bigStatusLabel.bottomAnchor, constant: 8),
            bigDescriptionLabel.leadingAnchor.constraint(equalTo: bigCardView.leadingAnchor, constant: 16),
            bigDescriptionLabel.trailingAnchor.constraint(equalTo: bigCardView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBackButton() {
            view.addSubview(backButton)

            let safe = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
                backButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
                backButton.heightAnchor.constraint(equalToConstant: 32)
            ])
        }

        @objc private func backButtonTapped() {
            if let nav = navigationController {
                nav.popViewController(animated: true)
            } else {
                dismiss(animated: true)
            }
        }

    private func setupMetricsBlock() {
        metricsBlockView.translatesAutoresizingMaskIntoConstraints = false
        metricsBlockView.backgroundColor = UIColor.systemGray5
        metricsBlockView.layer.cornerRadius = 24
        metricsBlockView.layer.masksToBounds = true

        view.addSubview(metricsBlockView)

        NSLayoutConstraint.activate([
            metricsBlockView.topAnchor.constraint(equalTo: bigCardView.bottomAnchor, constant: 16),
            metricsBlockView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            metricsBlockView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            metricsBlockView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func setupAdviceCard() {
        adviceCardView.translatesAutoresizingMaskIntoConstraints = false
        adviceCardView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
        adviceCardView.layer.cornerRadius = 24
        adviceCardView.layer.masksToBounds = true

        adviceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        adviceTitleLabel.text = "Health Advice"

        adviceTextLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceTextLabel.font = UIFont.systemFont(ofSize: 14)
        adviceTextLabel.numberOfLines = 0

        view.addSubview(adviceCardView)
        adviceCardView.addSubview(adviceTitleLabel)
        adviceCardView.addSubview(adviceTextLabel)
        
        let safe = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                adviceCardView.topAnchor.constraint(equalTo: metricsBlockView.bottomAnchor, constant: 16),
                adviceCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                adviceCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                adviceCardView.bottomAnchor.constraint(lessThanOrEqualTo: safe.bottomAnchor, constant: -16)
            ])

        NSLayoutConstraint.activate([
            adviceCardView.topAnchor.constraint(equalTo: metricsBlockView.bottomAnchor, constant: 16),
            adviceCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            adviceCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            adviceTitleLabel.topAnchor.constraint(equalTo: adviceCardView.topAnchor, constant: 16),
            adviceTitleLabel.leadingAnchor.constraint(equalTo: adviceCardView.leadingAnchor, constant: 16),
            adviceTitleLabel.trailingAnchor.constraint(equalTo: adviceCardView.trailingAnchor, constant: -16),

            adviceTextLabel.topAnchor.constraint(equalTo: adviceTitleLabel.bottomAnchor, constant: 8),
            adviceTextLabel.leadingAnchor.constraint(equalTo: adviceCardView.leadingAnchor, constant: 16),
            adviceTextLabel.trailingAnchor.constraint(equalTo: adviceCardView.trailingAnchor, constant: -16),
            adviceTextLabel.bottomAnchor.constraint(equalTo: adviceCardView.bottomAnchor, constant: -16)
        ])
    }

    

    private func updateBigCard() {
        let value = airQuality.value(for: currentMetric)
        let category = airQuality.category(for: currentMetric)

        bigCardView.backgroundColor = category.color
        bigValueLabel.text = "\(value)"
        bigStatusLabel.text = category.title
        bigDescriptionLabel.text = category.shortDescription
    }

    private func updateMetricsBlock() {
        metricsBlockView.subviews.forEach { $0.removeFromSuperview() }

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = "Detailed Metrics"

        metricsBlockView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: metricsBlockView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: metricsBlockView.leadingAnchor, constant: 16)
        ])

        func makeMetricCard(title: String, value: String) -> UIView {
            let card = UIView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.backgroundColor = .white
            card.layer.cornerRadius = 16
            card.layer.masksToBounds = true

            let t = UILabel()
            t.translatesAutoresizingMaskIntoConstraints = false
            t.font = UIFont.systemFont(ofSize: 13)
            t.text = title

            let v = UILabel()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.font = UIFont.boldSystemFont(ofSize: 16)
            v.text = value

            card.addSubview(t)
            card.addSubview(v)

            NSLayoutConstraint.activate([
                t.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
                t.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
                v.topAnchor.constraint(equalTo: t.bottomAnchor, constant: 4),
                v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
                v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -8)
            ])

            return card
        }

        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.alignment = .fill
        topRow.distribution = .fillEqually
        topRow.spacing = 12
        topRow.translatesAutoresizingMaskIntoConstraints = false

        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.alignment = .fill
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        metricsBlockView.addSubview(topRow)
        metricsBlockView.addSubview(bottomRow)

        let pm25Value = "\(airQuality.pm25) \(AirQualityMetric.pm25.unit)"
        let pm10Value = "\(airQuality.pm10) \(AirQualityMetric.pm10.unit)"
        let co2Value  = "\(airQuality.co2) \(AirQualityMetric.co2.unit)"
        let o3Value   = "\(airQuality.o3) \(AirQualityMetric.o3.unit)"

        topRow.addArrangedSubview(makeMetricCard(title: "PM2.5", value: pm25Value))
        topRow.addArrangedSubview(makeMetricCard(title: "PM10", value: pm10Value))
        bottomRow.addArrangedSubview(makeMetricCard(title: "CO₂", value: co2Value))
        bottomRow.addArrangedSubview(makeMetricCard(title: "O₃", value: o3Value))

        NSLayoutConstraint.activate([
            topRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            topRow.leadingAnchor.constraint(equalTo: metricsBlockView.leadingAnchor, constant: 16),
            topRow.trailingAnchor.constraint(equalTo: metricsBlockView.trailingAnchor, constant: -16),

            bottomRow.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 12),
            bottomRow.leadingAnchor.constraint(equalTo: metricsBlockView.leadingAnchor, constant: 16),
            bottomRow.trailingAnchor.constraint(equalTo: metricsBlockView.trailingAnchor, constant: -16),
            bottomRow.bottomAnchor.constraint(lessThanOrEqualTo: metricsBlockView.bottomAnchor, constant: -12)
        ])
    }

    private func updateAdvice() {
        let category = airQuality.category(for: currentMetric)
        adviceTextLabel.text = category.advice
    }

    @objc private func metricChanged() {
        guard let metric = AirQualityMetric(rawValue: metricSegmentedControl.selectedSegmentIndex) else { return }
        currentMetric = metric
        updateBigCard()
        updateAdvice()
    }
}

