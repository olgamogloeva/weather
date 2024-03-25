//
//  CityWeatherLayoutFactory.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

fileprivate enum CityWeatherItemsSizes {
    static let hourItemWidth: CGFloat = 150
    static let hourItemHeight: CGFloat = 80
    static let hourItemsSpacing: CGFloat = 20
    static let weekForeCastItemHeight: CGFloat = 100
    static let weekForeCastItemsSpacing: CGFloat = 4
    static let todayHeaderEstimatedheight: CGFloat = 200
    static let hourSectionInsets: NSDirectionalEdgeInsets = .init(top: 40, leading: 10, bottom: 10, trailing: 10)
    static let weekSectionInsets: NSDirectionalEdgeInsets = .init(top: 40, leading: 10, bottom: 10, trailing: 10)
}

typealias SectionProvider = (Int) -> CityWeatherSection?
typealias SectionOffsetProvider = (Int, CGPoint) -> Void

final class CityWeatherLayoutFactory {
    
    func createLayout(sectionProvider: @escaping SectionProvider) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let section = sectionProvider(sectionIndex) else { return nil }
            let sectionLayout = self?.makeSectionLayout(for: section)
            return sectionLayout
        }
        layout.configuration = makeConfiguration()
        return layout
    }

    // MARK: - Private
    
    private func makeConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return configuration
    }
    
    private func makeSectionLayout(for sectionType: CityWeatherSection) -> NSCollectionLayoutSection {
        switch sectionType {
        case .hourForecast:
            return makeHourForecastSection(with: sectionType.header)
        case .weekForecast:
            return makeWeekForecastSection(with: sectionType.header)
        }
    }
    
    private func makeHourForecastSection(with header: HeaderType?) -> NSCollectionLayoutSection {
        let carouselItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(CityWeatherItemsSizes.hourItemWidth),
            heightDimension: .absolute(CityWeatherItemsSizes.hourItemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontalSingleItemGroup(size: carouselItemSize)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = CityWeatherItemsSizes.hourItemsSpacing
        section.contentInsets = CityWeatherItemsSizes.hourSectionInsets
        addHeaderIfNeeded(headerType: header, section: section)
        return section
    }
    
    private func makeWeekForecastSection(with header: HeaderType?) -> NSCollectionLayoutSection {
        let securitySelectionItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(CityWeatherItemsSizes.weekForeCastItemHeight)
        )
        let group = NSCollectionLayoutGroup.verticalSingleItemGroup(size: securitySelectionItemSize)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CityWeatherItemsSizes.weekForeCastItemsSpacing
        section.contentInsets = CityWeatherItemsSizes.weekSectionInsets
     
        addHeaderIfNeeded(headerType: header, section: section)
        
        return section
    }
    
    private func addHeaderIfNeeded(
        headerType: HeaderType?,
        section: NSCollectionLayoutSection
    ) {
        guard let headerType else { return }
        let headerItem: NSCollectionLayoutBoundarySupplementaryItem
        switch headerType {
        case .todayWeatherInfo:
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(CityWeatherItemsSizes.todayHeaderEstimatedheight)
            )
            headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: CityWeatherCollectionElementKind.todayHeader.rawValue,
                alignment: .top
            )
        }
        section.boundarySupplementaryItems = [headerItem]
    }
}

fileprivate extension NSCollectionLayoutGroup {
    static func horizontalSingleItemGroup(size: NSCollectionLayoutSize) -> Self {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if #available(iOS 16.0, *) {
            return .horizontal(
                layoutSize: size,
                repeatingSubitem: item,
                count: 1
            )
        } else {
            return .horizontal(
                layoutSize: size,
                subitem: item,
                count: 1
            )
        }
    }
    
    static func verticalSingleItemGroup(size: NSCollectionLayoutSize) -> Self {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        if #available(iOS 16.0, *) {
            return .vertical(
                layoutSize: size,
                repeatingSubitem: item,
                count: 1
            )
        } else {
            return .vertical(
                layoutSize: size,
                subitem: item,
                count: 1
            )
        }
    }
}
