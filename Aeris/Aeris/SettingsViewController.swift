//
//  SettingsViewController.swift
//  Aeris
//
//  Created by Zhumatay Sayana on 07.12.2025.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var badAirSwitch: UISwitch!
    @IBOutlet var metricButtons: [UIButton]!    // buttons for PM2.5, PM10, CO2, O3
    @IBOutlet weak var clearCacheButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var notificationsCard: UIView!
    @IBOutlet weak var defaultMetricCard: UIView!
    @IBOutlet weak var dataManagementCard: UIView!
    @IBOutlet weak var aboutCard: UIView!

    private let metricsOrder: [Metric] = [.pm25, .pm10, .co2, .o3]   // order to map buttons to metrics

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"

        setupUI()
        loadState()

        styleCards()
        styleMetricButtons()
        styleClearCacheButton()
        alignStackViews()
        loadVersion()
    }


    private func setupUI() {
        metricButtons.forEach { btn in
            btn.layer.cornerRadius = 12
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.systemGray4.cgColor
            btn.setTitleColor(.label, for: .normal)
            btn.clipsToBounds = true
        }

        clearCacheButton.layer.cornerRadius = 12
        clearCacheButton.layer.borderWidth = 1
        clearCacheButton.layer.borderColor = UIColor.systemRed.cgColor
        clearCacheButton.setTitleColor(.systemRed, for: .normal)

        loadVersion()
    }

    private func loadVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(version)"
        }
    }


    private func styleCards() {
        let cards = [notificationsCard, defaultMetricCard, dataManagementCard, aboutCard]

        cards.forEach { card in
            //card?.backgroundColor = UIColor.systemGray6
            card?.layer.cornerRadius = 16
            card?.layer.masksToBounds = true

            card?.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            card?.preservesSuperviewLayoutMargins = true
        }
    }

    private func styleMetricButtons() {
        metricButtons.forEach { btn in
            btn.layer.cornerRadius = 12
            btn.layer.borderWidth = 1
            btn.layer.borderColor = UIColor.systemGray4.cgColor
            btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            btn.setTitleColor(.label, for: .normal)
            btn.clipsToBounds = true
            
            btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }

    private func styleClearCacheButton() {
        clearCacheButton.layer.cornerRadius = 12
        clearCacheButton.layer.borderWidth = 1
        clearCacheButton.layer.borderColor = UIColor.systemRed.cgColor
        clearCacheButton.setTitleColor(.systemRed, for: .normal)
        clearCacheButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        clearCacheButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    private func alignStackViews() {
        view.subviewsRecursive
            .compactMap { $0 as? UIStackView }
            .forEach { stack in
                stack.spacing = 12
                stack.isLayoutMarginsRelativeArrangement = true
                stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
    }


    private func loadState() {
        badAirSwitch.isOn = SettingsManager.shared.hasNotifications
        updateMetricSelectionUI()
    }

    private func updateMetricSelectionUI() {
        let current = SettingsManager.shared.defaultMetric

        for (i, btn) in metricButtons.enumerated() {
            let metric = metricsOrder[i]
            btn.backgroundColor = (metric == current) ? UIColor.systemGray4 : .clear
        }
    }

    @IBAction func badAirSwitchChanged(_ sender: UISwitch) {
        SettingsManager.shared.hasNotifications = sender.isOn
        
        if sender.isOn {
            // ask permission for notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    @IBAction func metricButtonTapped(_ sender: UIButton) {
        guard let index = metricButtons.firstIndex(of: sender) else { return }
        let metric = metricsOrder[index]
        SettingsManager.shared.defaultMetric = metric
        updateMetricSelectionUI()
        NotificationCenter.default.post(name: .didChangeDefaultMetric, object: nil)
    }

    @IBAction func clearCacheTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear cache?", message: "This will remove cached API data.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            SettingsManager.shared.clearCache()
            
            let ok = UIAlertController(title: nil, message: "Cache cleared", preferredStyle: .alert)
            self.present(ok, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { ok.dismiss(animated: true) }
            }
        })
        present(alert, animated: true)
    }
}

//to get all subviews
extension UIView {
    var subviewsRecursive: [UIView] {
        subviews + subviews.flatMap { $0.subviewsRecursive }
    }
}
// notification for default metric change
extension Notification.Name {
    static let didChangeDefaultMetric = Notification.Name("didChangeDefaultMetric")
}
