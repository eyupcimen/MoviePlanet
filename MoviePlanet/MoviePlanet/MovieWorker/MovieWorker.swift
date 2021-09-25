//
//  MovieWorker.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import Foundation

public class MovieWorker {
    
    var moviesStore: MovieStoreProtocol
    init(moviesStore: MovieStoreProtocol) {
        self.moviesStore = moviesStore
    }
    
    func getUpcomingList(_ completion: @escaping ([Movie]) -> ()) {
        NetworkAdapter.shared.request(AppConst.mainUrl) {  (response : BaseResult<Movie>) in
            completion(response.results!)
        } failure: {}
    }
    
    func getSliderMovieList(_ completion: @escaping ([Movie]) -> ()) {
        NetworkAdapter.shared.request(AppConst.sliderUrl) { (response : BaseResult<Movie>) in
            completion(response.results!)
        } failure: {}
    }
    
    func getSearchMovieList(keyword: String, _ completion: @escaping ([Movie]) -> ()) {
        NetworkAdapter.shared.request(AppConst.searchUrl + keyword) { (response : BaseResult<Movie>) in
            completion(response.results!)
        } failure: {}
    }
    
    func getMovieDetail(movieId:Int, _ completion: @escaping (Movie) -> ()) {
        let movieDetailUrl = AppConst.detailUrl.replacingOccurrences(of: "{movie_id}", with: String(movieId))
        NetworkAdapter.shared.request(movieDetailUrl) { (response : Movie) in
            completion(response)
        } failure: {}
    }
    
    func getSimilarMovies(movieId:Int,_ completion: @escaping ([Movie]) -> ()) {
        let similarUrl = AppConst.similarUrl.replacingOccurrences(of: "{movie_id}", with: String(movieId))
        NetworkAdapter.shared.request(similarUrl) {  (response : BaseResult<Movie>) in
            completion(response.results!)
        } failure: {}
    }
}

protocol MovieStoreProtocol {
    func getUpcomingList(_ completion : @escaping ([Movie])->())
}

protocol MoviesStoreUtilityProtocol {}

extension MoviesStoreUtilityProtocol { }
 
