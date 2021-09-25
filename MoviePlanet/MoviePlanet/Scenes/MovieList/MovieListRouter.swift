//
//  MovieListRouter.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MovieListRoutingLogic {
    func routeToShowMovieDetail(segue: UIStoryboardSegue?, movieId :Int)
}

protocol MovieListDataPassing {
    var dataStore: MovieListDataStore? { get }
}

class MovieListRouter: NSObject, MovieListRoutingLogic, MovieListDataPassing {
    
    weak var viewController: MovieListViewController?
    var dataStore: MovieListDataStore?
    
    func routeToShowMovieDetail(segue: UIStoryboardSegue?, movieId :Int) {
        
        if let segue = segue {
            let destinationVC = segue.destination as! MovieDetailViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowOrder(source: dataStore!, destination: &destinationDS,movieId: movieId)
        }
    }
    
    func navigateToShowOrder(source: MovieListViewController , destination: MovieDetailViewController) {
        source.show(destination, sender: nil)
    }
    
    func passDataToShowOrder(source: MovieListDataStore , destination: inout MovieDetailDataStore, movieId :Int) {
        destination.movieId = movieId
    }
}