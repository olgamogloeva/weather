//
//  CityWeatherVC+CellProvider.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

extension CityWeatherViewController {
    func cellProvider(
        collection: UICollectionView,
        indexPath: IndexPath,
        item: CityWeatherScreenItem
    ) -> UICollectionViewCell? {
        var imageViewToSet: UIImageView?
        var iconPath = ""
        var cellToReturn: UICollectionViewCell?
        
        switch item {
        case .hourWeather(let model):
            let cell: HourWeatherCollectionCell = collection.dequeueCell(for: indexPath)
            imageViewToSet = cell.wrappedView.imageView
            iconPath = model.icon
            cell.update(with: model)
            cellToReturn = cell
        case .dayWeather(let model):
            let cell: DayWeatherCollectionCell = collection.dequeueCell(for: indexPath)
            cell.update(with: model)
            imageViewToSet = cell.wrappedView.imageView
            iconPath = model.icon
            cellToReturn = cell
        }
        
        if let imageViewToSet {
            ImageDownloader.shared.downloadImage(
                with: "https://openweathermap.org/img/wn/\(iconPath).png",
                completionHandler: { dowloadedImage, flag in
                    DispatchQueue.main.async {
                        imageViewToSet.image = dowloadedImage
                    }
                },
                placeholderImage: UIImage(systemName: "slowmo")
            )
        }
        return cellToReturn
    }
    
    func supplementaryViewProvider(
        collection: UICollectionView,
        kind: String,
        indexPath: IndexPath
    ) -> UICollectionReusableView? {
        guard let supplementaryKind = CityWeatherCollectionElementKind(rawValue: kind) else { return nil }
        let section = presenter?.section(at: indexPath.section)
        
        switch supplementaryKind {
        case .todayHeader:
            guard case .todayWeatherInfo(let model) = section?.header else { return nil }
            let headerView: TodayWeatherHeader = collection.dequeueSupplementary(kind: kind, for: indexPath)
            headerView.update(with: model)
            return headerView
        }
    }
}
