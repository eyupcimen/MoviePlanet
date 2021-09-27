//
//  Seeds.swift
//  MoviePlanetTests
//
//  Created by eyup cimen on 25.09.2021.
//

import Foundation
@testable import MoviePlanet

struct Seeds {
    
  struct Movies {
    
    static let movie1 = Movie(dic: [
                                "id": 1234,
                                "title": "test movie",
                                "releaseDate": "12.03.2020",
                                "overview" : "test overview",
                                "voteAverage" : 7.0,
                                "imdbLink" : "test link",
                                "backdropPath" : "backdroppath",
                                "posterPath" : "posterpath"])
    
    static let movie2 = Movie(dic: [
                                "id": 12345,
                                "title": "test movie s2",
                                "releaseDate": "12.03.2020",
                                "overview" : "test overview 2",
                                "voteAverage" : 7.0,
                                "imdbLink" : "test link 2",
                                "backdropPath" : "backdroppath",
                                "posterPath" : "posterpath"])
    
    static let movie3 = Movie(dic: [
                                "id": 123456,
                                "title": "test movie3",
                                "releaseDate": "12.03.2020",
                                "overview" : "test overview 3",
                                "voteAverage" : 7.0,
                                "imdbLink" : "test link 3",
                                "backdropPath" : "backdroppath",
                                "posterPath" : "posterpath"])
  }
}
