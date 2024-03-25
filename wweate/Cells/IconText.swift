//
//  IconText.swift
//  wweate
//
//  Created by Olga Mogloeva on 25.03.2024.
//

import UIKit

final class IconText: UIView {
    
    let condition: TodayWeatherView.Model.Conditions
    
    // MARK: - Init
    
    init(condition: TodayWeatherView.Model.Conditions) {
        self.condition = condition
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let imageView = UIImageView()
        imageView.image = condition.image
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        let label = UILabel()
        addSubview(label)
        label.textColor = .black
        label.text = condition.title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
