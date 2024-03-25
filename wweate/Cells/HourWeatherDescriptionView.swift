//
//  HourWeatherDescriptionView.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

typealias HourWeatherCollectionCell = CollectionCell<HourWeatherView>


final class HourWeatherView: UIView {
    
    struct Model: Hashable {
        let date: String
        let temperature: String
        let description: String
        let icon: String
    }
    
    let imageView = UIImageView()
    private let dateLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let vStack = UIStackView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        vStack.axis = .vertical
        addSubview(vStack)
        vStack.pinToEdges(of: self)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        [imageView, dateLabel, tempLabel, descriptionLabel].forEach { vStack.addArrangedSubview($0) }
    }
}

// MARK: - Reusable

extension HourWeatherView: Reusable {
    func prepareForReuse() {
        [dateLabel, tempLabel, descriptionLabel].forEach { $0.text = nil }
        imageView.image = nil
    }
}

// MARK: - Updatable

extension HourWeatherView: Updatable {
    func update(with model: Model) {
        dateLabel.text = model.date
        tempLabel.text = model.temperature
        descriptionLabel.text = model.description
        
    }
}
