//
//  UIView+Extension.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

extension UIView { 
    func pinToEdges(of parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
