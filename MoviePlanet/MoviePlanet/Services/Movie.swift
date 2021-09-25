//
//  Movie.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import Foundation

public class BaseResult<T: Decodable> : Decodable {

    var results: [T]?
    
    init(){}
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([T].self , forKey: .results)!
    }
}

public struct Movie : Codable {

    var Id : Int?
    var Title : String?
    var Overview : String?
    var VoteAverage : Double?
    var ImdbLink : String?
    var BackdropPath : String?
    var PosterPath : String?
    var ReleaseDate : String = "" {
        didSet {
            if !ReleaseDate.isEmpty {
                Title = Title! + " (" + ReleaseDate.prefix(4) + ")"
                let arr = ReleaseDate.split(separator: "-")
                ReleaseDate = arr.reversed().joined(separator: ".")
            }
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case Title = "title"
        case ReleaseDate = "release_date"
        case Overview = "overview"
        case ImdbLink = "imdb_id"
        case VoteAverage = "vote_average"
        case BackdropPath = "backdrop_path"
        case PosterPath = "poster_path"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Id = try values.decodeIfPresent(Int.self , forKey: .Id)
        Title = try values.decodeIfPresent(String.self , forKey: .Title)
        ReleaseDate = try values.decodeIfPresent(String.self , forKey: .ReleaseDate) ?? ""
        Overview = try values.decodeIfPresent(String.self , forKey: .Overview)
        VoteAverage = try values.decodeIfPresent(Double.self , forKey: .VoteAverage)
        ImdbLink = try values.decodeIfPresent(String.self , forKey: .ImdbLink)
        ImdbLink = AppConst.imdbUrl + (ImdbLink ?? "")
        BackdropPath = try values.decodeIfPresent(String.self , forKey: .BackdropPath)
        BackdropPath = AppConst.imageUrl + (BackdropPath ?? "")
        PosterPath = try values.decodeIfPresent(String.self , forKey: .PosterPath)
        PosterPath = AppConst.imageUrl + (PosterPath ?? "")
    }
    
}
