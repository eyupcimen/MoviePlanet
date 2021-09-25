//
//  RequestManager.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import Foundation

struct AppConst {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let additionalValues = "?api_key=b7cd3340a794e5a2f35e3abb820b497f&language=en-US&page=1"
    static let sliderUrl  = baseUrl + "/movie/now_playing" + additionalValues
    static let mainUrl  = baseUrl + "/movie/upcoming" + additionalValues
    static let searchUrl  = baseUrl + "/search/movie" + additionalValues + "&query="
    static let detailUrl  = baseUrl + "/movie/{movie_id}" + additionalValues
    static let similarUrl = baseUrl + "/movie/{movie_id}/similar" + additionalValues
    static let imageUrl = "https://image.tmdb.org/t/p/w500/"
    static let imdbUrl = "https://www.imdb.com/title/"
}

final class NetworkAdapter {
    
    static var shared = NetworkAdapter()
    var isLoading : Bool = false {
        didSet {
           if self.isLoading {
                Util.shared.showHud()
            }else {
                Util.shared.removeHud()
            }
        }
    }
    
    public func request<T: Decodable> (_ url: String,_ parameters: [String : Any] = [:], _ method: String = "GET",_ httpHeaders: String? = nil, success: @escaping (T) -> Void, failure: @escaping () -> () ) {
        
        self.isLoading = true
        let newUrl = Util.shared.encodeUrl(url)
        
        let postData = NSData(data: "".data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: newUrl )! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 30.0)
        request.httpMethod = method
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil || data == nil {
                print(error)
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            self.isLoading = false
            do {
                let movieObject = try JSONDecoder().decode(T.self, from: data! )
                success(movieObject)
            } catch {
                failure()
            }
        })
        dataTask.resume()
    }
}
