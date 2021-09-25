//
//  MoviesMemStore.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import Foundation

class MoviesMemStore : MovieStoreProtocol , MoviesStoreUtilityProtocol {
    func getUpcomingList(_ completion: @escaping ([Movie]) -> ()) {}
}
