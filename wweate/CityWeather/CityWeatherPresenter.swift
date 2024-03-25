//
//  WeatherPresenter.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import Foundation

protocol ICityWeatherPresenter {
    func viewDidLoad()
    func refresh()
    func section(at index: Int) -> CityWeatherSection?
}

final class CityWeatherPresenter {
    
    weak var view: ICityWeatherView?
    
    private var sections: [CityWeatherSection] = []
    private var modelFactory: CityWeatherModelFactory
    private let todayNetworkService: ITodayWeatherNetowrkService
    private let forecastNetworkService: IWeekForecastNetworkService

    // MARK: - Init
    
    init(
        modelFactory: CityWeatherModelFactory,
        todaynetworkService: ITodayWeatherNetowrkService,
        forecastNetworkService: IWeekForecastNetworkService
    ) {
        self.modelFactory = modelFactory
        self.todayNetworkService = todaynetworkService
        self.forecastNetworkService = forecastNetworkService
    }
    
   
    // MARK: - Private
    
    private func fetchData(showLoading: Bool = false) {
        if showLoading {
            view?.handleStateChange(state: .loading)
        }
        let group = DispatchGroup()
        var currentWeather: (CurrentWeatherResponse)?
        var forecast: ForecastWeatherResponse?
        
        group.enter()
        let coord = NetworkConstants.msc
        todayNetworkService.getWeather(coordinate: coord) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                currentWeather = model
            case .failure(let error):
                self.view?.handleStateChange(state: .error(error))
            }
            group.leave()
        }
        
        group.enter()
        forecastNetworkService.fetchForecast(coordinate: coord) { [weak self] result in
            switch result {
            case .success(let success):
                forecast = success
            case .failure(let error):
                self?.view?.handleStateChange(state: .error(error))
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let currentWeather, let forecast else { return }
            self.sections = self.modelFactory.createSections(
                currentWeather: currentWeather,
                forecast: forecast
            )
            let newSnapshot = self.makeSnapshot(from: self.sections)
            self.view?.handleStateChange(state: .ready(newSnapshot))
        }
    }
    
    private func makeSnapshot(from sections: [CityWeatherSection]) -> CityWeatherSnapshot {
        var snapshot = CityWeatherSnapshot()
        sections.forEach { section in
            snapshot.appendSections([section.id])
            snapshot.appendItems(section.items, toSection: section.id)
        }
        return snapshot
    }
}

// MARK: - ICityWeatherPresenter

extension CityWeatherPresenter: ICityWeatherPresenter {
    func viewDidLoad() {
        fetchData(showLoading: true)
    }
    
    func section(at index: Int) -> CityWeatherSection? {
        guard index < sections.count else { return nil }
        return sections[index]
    }
    
    func refresh() {
        fetchData()
    }
}
