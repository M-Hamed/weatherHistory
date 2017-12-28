//
//  WeatherHistoryPresenter.swift
//  Weather History
//
//  Created by Mohamed Hamed on 12/28/17.
//  Copyright © 2017 Hamed. All rights reserved.
//

import Foundation
import UIKit

class WeatherHistoryPresenter:  NSObject {
    
    unowned var viewController : UIViewController
    unowned var collectionView : UICollectionView
    
    var delegate    : WeatherHistoryDelegate!
    var dataSource  : WeatherHistoryDataSource!
    
    
    init(viewController: UIViewController, collectionView: UICollectionView) {
        self.viewController = viewController
        self.collectionView = collectionView
        
        super.init()
        delegate            = WeatherHistoryDelegate(presenter: self)
        dataSource          = WeatherHistoryDataSource(presenter: self)
        setupCollectionView()
    }
    
    func requestWeatherData(onSuccess: @escaping (Weather) -> (),
                            onFailure: @escaping (Error) -> ()) {
        
        if let location = (viewController as? WeatherHistoryViewController)?.locationManager.location {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let currentLanguage = Bundle.main.preferredLocalizations.first ?? "en"
            
            WeatherService.current(lat: lat, long: long, units: "metric", language: currentLanguage, onSuccess: { weather in
                onSuccess(weather)
            }, onFailure: { error in
                onFailure(error)
            })
        }
    }
}


private extension WeatherHistoryPresenter {
    var cells: [UICollectionViewCell.Type] {
        return []
    }
    
    func setupCollectionView() {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        registerCells()
    }
    
    func registerCells() {
        cells.forEach { cellKlass in
            let cellName = String(describing: cellKlass)
            let nib      = UINib(nibName: cellName, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellName)
        }
    }
}
