//
//  TodayWeatherView.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

typealias TodayWeatherHeader = CollectionSupplementary<TodayWeatherView>

final class TodayWeatherView: UIView {

    struct Model {
        struct Temp {
            let current: String
            let min: String
            let max: String
        }
        
        struct Conditions {
            let image: UIImage
            let title: String
        }
        
        let city: String
        let temperature: Temp
        let condition: [Conditions]
    }
    
    private let hStack = UIStackView()
    private let cityNameLabel = UILabel()
    private let tempLabel = UILabel()
    private let maxTempLabel = UILabel()
    private let minTempLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Reusable

extension TodayWeatherView: Reusable {
    func prepareForReuse() {
        hStack.clear()
    }
}

// MARK: - Updatable

extension TodayWeatherView: Updatable {
    func update(with model: Model) {
        cityNameLabel.text = model.city
        tempLabel.text = model.temperature.current
        maxTempLabel.text = model.temperature.max
        minTempLabel.text = model.temperature.min
        model.condition.forEach { condtion in
            let iconTextView = IconText(condition: condtion)
            iconTextView.translatesAutoresizingMaskIntoConstraints = true
            hStack.addArrangedSubview(iconTextView)
        }
    }
    
    func setupUI() {
        addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.font = .boldSystemFont(ofSize: 30)
        NSLayoutConstraint.activate([
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityNameLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
        
        addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = .boldSystemFont(ofSize: 30)
        NSLayoutConstraint.activate([
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 90)
        ])
        
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        hStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        hStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        hStack.spacing = 10
        hStack.distribution = .fillEqually

    }
}
