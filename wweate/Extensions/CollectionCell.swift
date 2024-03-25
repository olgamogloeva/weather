//
//  Cell.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

 protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        .init(describing: Self.self)
    }
}

protocol Reusable: ReuseIdentifiable {
    func prepareForReuse()
}

 protocol Updatable<Model>: AnyObject {
    associatedtype Model
    func update(with model: Model)
}

 final class CollectionCell<T>: UICollectionViewCell,
    Reusable,
    Updatable
where
    T: UIView,
    T: Updatable,
    T: Reusable {

     private(set) lazy var wrappedView: T = {
        return T(frame: bounds)
    }()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(wrappedView)
        wrappedView.pinToEdges(of: contentView)
    }

     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reusable

     static var reuseIdentifier: String {
        T.reuseIdentifier
    }

    override  func prepareForReuse() {
        super.prepareForReuse()
        wrappedView.prepareForReuse()
    }

    // MARK: - Updatable

     func update(with model: T.Model) {
        wrappedView.update(with: model)
    }
}


