//
//  DayWeatherDescriptionView.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

typealias DayWeatherCollectionCell = CollectionCell<DayWeatherView>

final class DayWeatherView: UIView {
    
    struct Model: Hashable {
        let date: String
        let icon: String
        let temperature: String
    }
    
    let imageView = UIImageView()
    private let dateLabel = UILabel()
    private let tempLabel = UILabel()
    private let hStack = UIStackView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        hStack.axis = .horizontal
        hStack.spacing = 80
        addSubview(hStack)
        hStack.pinToEdges(of: self)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        [dateLabel, imageView, tempLabel].forEach { hStack.addArrangedSubview($0) }
    }
}

// MARK: - Reusable

extension DayWeatherView: Reusable {
    func prepareForReuse() {
        [dateLabel, tempLabel].forEach { $0.text = nil }
        imageView.image = nil
    }
}

// MARK: - Updatable

extension DayWeatherView: Updatable {
    func update(with model: Model) {
        dateLabel.text = model.date
        tempLabel.text = model.temperature
    }
}
