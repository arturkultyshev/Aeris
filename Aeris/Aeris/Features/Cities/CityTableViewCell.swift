//
//  CityTableViewCell.swift
//  Aeris
//
//  Created by Артур Култышев on 07.12.2025.
//

import UIKit

final class CityTableViewCell: UITableViewCell {

    static let reuseId = "CityTableViewCell"

    private let cardView = UIView()
    private let backgroundImageView = UIImageView()
    private let valueContainerView = UIView()
    private let valueLabel = UILabel()
    private let cityNameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusButton = UIButton(type: .system)

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

        valueContainerView.translatesAutoresizingMaskIntoConstraints = false
        valueContainerView.layer.cornerRadius = 32
        valueContainerView.layer.masksToBounds = true

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.textAlignment = .center

        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 18)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 11)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        statusButton.translatesAutoresizingMaskIntoConstraints = false
        statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        statusButton.setTitleColor(.white, for: .normal)
        statusButton.layer.cornerRadius = 16
        statusButton.layer.masksToBounds = true
        statusButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)

        contentView.addSubview(cardView)
        cardView.addSubview(backgroundImageView)
        cardView.addSubview(valueContainerView)
        valueContainerView.addSubview(valueLabel)
        cardView.addSubview(cityNameLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(statusButton)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            backgroundImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 160),

            valueContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            valueContainerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 24),
            valueContainerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            valueContainerView.widthAnchor.constraint(equalToConstant: 64),
            valueContainerView.heightAnchor.constraint(equalToConstant: 64),

            valueLabel.centerXAnchor.constraint(equalTo: valueContainerView.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: valueContainerView.centerYAnchor),

            cityNameLabel.leadingAnchor.constraint(equalTo: valueContainerView.trailingAnchor, constant: 16),
            cityNameLabel.topAnchor.constraint(equalTo: valueContainerView.topAnchor, constant: 4),

            subtitleLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusButton.leadingAnchor, constant: -8),

            statusButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            statusButton.centerYAnchor.constraint(equalTo: valueContainerView.centerYAnchor),
            statusButton.widthAnchor.constraint(equalToConstant: 104),
            statusButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    func configure(with city: City, metric: AirQualityMetric) {
        backgroundImageView.image = UIImage(named: city.imageName)
        cityNameLabel.text = city.name

        guard let air = city.airQuality else {
            valueLabel.text = "--"
            subtitleLabel.text = "Loading..."
            valueContainerView.backgroundColor = .systemGray4
            statusButton.setTitle("Loading…", for: .normal)
            statusButton.backgroundColor = .systemGray4
            return
        }

        let value = air.value(for: metric)
        let category = air.category(for: metric)

        valueLabel.text = "\(value)"
        valueContainerView.backgroundColor = category.color

        statusButton.setTitle(category.title, for: .normal)
        statusButton.backgroundColor = category.color

        // 🔥 ДИНАМИЧЕСКИЙ SUBTITLE
        // Короткая фраза под названием города
        subtitleLabel.text = category.shortDescription
        // Если хочешь чуть длиннее текст — можешь использовать:
        // subtitleLabel.text = category.advice
    }

}

