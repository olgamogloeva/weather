//
//  UIStackView+Extension.swift
//  wweate
//
//  Created by Olga Mogloeva on 25.03.2024.
//

import UIKit

extension UIStackView {
    func clear() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
    }
}
