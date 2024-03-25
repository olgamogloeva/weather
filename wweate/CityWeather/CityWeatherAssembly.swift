//
//  CityWeatherAssembly.swift
//  wweate
//
//  Created by Olga Mogloeva on 25.03.2024.
//

import UIKit

enum CityWeatherAssembly {
    static func assembly() -> UIViewController {
        let viewController = CityWeatherViewController()
        let presenter = CityWeatherPresenter(
            modelFactory: CityWeatherModelFactory(),
            todaynetworkService: TodayWeatherNetowrkService(network: Network()),
            forecastNetworkService: WeekForecastNetworkService(network: Network())
        )
        viewController.presenter = presenter
        presenter.view = viewController
        return viewController
    }
}
