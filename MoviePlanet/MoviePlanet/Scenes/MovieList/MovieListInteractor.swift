//
//  MovieListInteractor.swift
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

protocol MovieListBusinessLogic {
    func fetchMovies(request: ListMovies.FetchMovies.Request)
    func fetchSliderMovies(request: ListMovies.FetchSlidersMovies.Request)
    func fetchSearchMovies(keyword: String,request: ListMovies.FetchSearchMovies.Request)
}

protocol MovieListDataStore {
    var movies : [Movie]? {get}
}

class MovieListInteractor: MovieListBusinessLogic, MovieListDataStore {
    var presenter: MovieListPresentationLogic?
    var moviesWorker = MovieWorker(moviesStore : MoviesMemStore() )
    var movies: [Movie]?
    
    func fetchMovies(request: ListMovies.FetchMovies.Request) {
        moviesWorker.getUpcomingList { (movies) in
            self.movies = movies
            let response = ListMovies.FetchMovies.Response(movies: movies)
            self.presenter?.presentFetchedMovies(response: response)
        }
    }
    
    func fetchSliderMovies(request: ListMovies.FetchSlidersMovies.Request) {
        moviesWorker.getSliderMovieList { (movies) in
            self.movies = movies
            let response = ListMovies.FetchSlidersMovies.Response(movies: movies)
            self.presenter?.presentSliderMovies(response: response)
        }
    }
    
    func fetchSearchMovies(keyword: String, request: ListMovies.FetchSearchMovies.Request) {
        moviesWorker.getSearchMovieList(keyword: keyword) { (movies) in
            self.movies = movies
            let response = ListMovies.FetchSearchMovies.Response(movies: movies)
            self.presenter?.presentSearchMovies(response: response)
        }
    }
}
