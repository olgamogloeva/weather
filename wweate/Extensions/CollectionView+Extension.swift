//
//  CollectionView+Extension.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

extension UICollectionView {
     func register<T: UICollectionViewCell & ReuseIdentifiable>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

     func register<T: UICollectionReusableView & ReuseIdentifiable>(_ supplementary: T.Type, of kind: String) {
        register(supplementary, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

     func dequeueSupplementary<T: UICollectionReusableView & ReuseIdentifiable>(
        kind: String,
        for indexPath: IndexPath
    ) -> T {
        let supplementary = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T

        guard let supplementary = supplementary else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.reuseIdentifier) and kind: \(kind)")
        }
        return supplementary
    }

     func dequeueCell<T: UICollectionViewCell & ReuseIdentifiable>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
