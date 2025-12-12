//
//  TrendingCityTableViewCell.swift
//  Aeris
//
//  Created by Артур Култышев on 12.12.2025.
//


import UIKit

final class TrendingCityTableViewCell: UITableViewCell {

    static let reuseId = "TrendingCityTableViewCell"

    private let cardView = UIView()
    private let backgroundImageView = UIImageView()
    private let cityNameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let metricsStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 24
        cardView.layer.masksToBounds = true

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.font = .boldSystemFont(ofSize: 18)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 11)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        metricsStackView.translatesAutoresizingMaskIntoConstraints = false
        metricsStackView.axis = .horizontal
        metricsStackView.alignment = .fill
        metricsStackView.distribution = .equalSpacing
        metricsStackView.spacing = 8

        contentView.addSubview(cardView)
        cardView.addSubview(backgroundImageView)
        cardView.addSubview(cityNameLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(metricsStackView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            backgroundImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 160),

            metricsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            metricsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            metricsStackView.heightAnchor.constraint(equalToConstant: 40),

            cityNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cityNameLabel.bottomAnchor.constraint(equalTo: metricsStackView.topAnchor, constant: -8),

            subtitleLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: cityNameLabel.topAnchor, constant: -2)
        ])
    }

    // Один кружочек под метрику
    private func makeMetricChip(valueText: String,
                                color: UIColor,
                                isHighlighted: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        container.backgroundColor = color

        if isHighlighted {
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = valueText

        container.addSubview(label)

        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 40),
            container.heightAnchor.constraint(equalToConstant: 40),

            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        return container
    }

    func configure(with city: City, highlightedMetric: AirQualityMetric) {
        backgroundImageView.image = UIImage(named: city.imageName)
        cityNameLabel.text = city.name
        subtitleLabel.text = city.subtitle

        metricsStackView.arrangedSubviews.forEach {
            metricsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard let air = city.airQuality else {
            // Плашки пустые, если данных нет
            for _ in AirQualityMetric.allCases {
                let chip = makeMetricChip(valueText: "--",
                                          color: .systemGray4,
                                          isHighlighted: false)
                metricsStackView.addArrangedSubview(chip)
            }
            return
        }

        for metric in AirQualityMetric.allCases {
            let value = air.value(for: metric)
            let category = air.category(for: metric)

            let chipColor: UIColor = (metric == highlightedMetric)
                ? category.color
                : UIColor.systemGray5

            let chip = makeMetricChip(valueText: "\(value)",
                                      color: chipColor,
                                      isHighlighted: metric == highlightedMetric)
            metricsStackView.addArrangedSubview(chip)
        }
    }
}
