//
//  ViewController.swift
//  wweate
//
//  Created by Olga Mogloeva on 24.03.2024.
//

import UIKit

typealias SectionId = String

enum CityWeatherScreenItem: Hashable {
    case hourWeather(HourWeatherView.Model)
    case dayWeather(DayWeatherView.Model)
}

enum CityWeatherCollectionElementKind: String {
    case todayHeader = "UICollectionElementKindHeader"
}

typealias CityWeatherDataSource = UICollectionViewDiffableDataSource<SectionId, CityWeatherScreenItem>
typealias CityWeatherSnapshot = NSDiffableDataSourceSnapshot<SectionId, CityWeatherScreenItem>

protocol ICityWeatherView: AnyObject {
    func handleStateChange(state: CityWeatherModuleState)
}

final class CityWeatherViewController: UIViewController, UICollectionViewDelegate {

    var presenter : ICityWeatherPresenter?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
    private lazy var diffableQueue = DispatchQueue(label: "cityWeather-diffable-queue", qos: .userInitiated)
    private lazy var diffableDataSource = makeDiffableDataSource()
    private let layoutFactory = CityWeatherLayoutFactory()
    private lazy var activityIndicator: UIActivityIndicatorView = self.produceActivityIndicator()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didTriggerPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.pinToEdges(of: view)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = diffableDataSource
        registerCells()
    }
    
    private func registerCells() {
        collectionView.register(TodayWeatherHeader.self, of: CityWeatherCollectionElementKind.todayHeader.rawValue)
        collectionView.register(HourWeatherCollectionCell.self)
        collectionView.register(DayWeatherCollectionCell.self)
    }
    
    private func makeDiffableDataSource() -> CityWeatherDataSource {
        let dataSource = CityWeatherDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item in
            self?.cellProvider(collection: collection, indexPath: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collection, kind, indexPath in
            self?.supplementaryViewProvider(collection: collection, kind: kind, indexPath: indexPath)
        }
        return dataSource
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider: SectionProvider = { [weak self] sectionIndex in
            guard let sectionType = self?.presenter?.section(at: sectionIndex)  else { return nil }
            return sectionType
        }
    
        return layoutFactory.createLayout(
            sectionProvider: sectionProvider
        )
    }
    
    private func stopRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    private func produceActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.layer.zPosition = .infinity
        self.view.insertSubview(spinner, aboveSubview: self.collectionView)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.collectionView.centerYAnchor)
        ])
        spinner.hidesWhenStopped = true
        spinner.color = .red
        return spinner
    }
    
    private func showAlert(title: String) {
        let alertVC = UIAlertController(title: "Smth went wrong", message: title, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertVC, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func didTriggerPullToRefresh() {
        presenter?.refresh()
    }
}

// MARK: - ICityWeatherView

extension CityWeatherViewController: ICityWeatherView {
    func handleStateChange(state: CityWeatherModuleState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
        case .ready(let snapshot):
            activityIndicator.stopAnimating()
            diffableQueue.async {
                self.diffableDataSource.apply(snapshot)
            }
            stopRefreshing()
        case .error(let error):
            showAlert(title: error.localizedDescription)
        }
    }
}
