//
//  Supplementary.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

 final class CollectionSupplementary<T>: UICollectionReusableView,
    Reusable,
    Updatable
where
    T: UIView,
    T: Updatable,
    T: Reusable {
     private(set) lazy var containedView: T = {
        return T(frame: bounds)
    }()

    // MARK: - Initialization

    override  init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        addSubview(containedView)
        containedView.pinToEdges(of: self)
    }

     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reusable

    override  func prepareForReuse() {
        super.prepareForReuse()
        containedView.prepareForReuse()
    }

    // MARK: - Configurable

     func update(with model: T.Model) {
        containedView.update(with: model)
    }
}
