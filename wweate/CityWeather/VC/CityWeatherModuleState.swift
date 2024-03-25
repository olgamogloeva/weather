//
//  CityWeatherModuleState.swift
//  wweate
//
//  Created by Olga Mogloeva on 25.03.2024.
//

import Foundation

enum CityWeatherModuleState {
    case loading
    case ready(CityWeatherSnapshot)
    case error(Error)
}
