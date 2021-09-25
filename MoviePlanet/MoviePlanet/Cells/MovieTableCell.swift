//
//  MovieTableCell.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//


import UIKit
import Kingfisher

class MovieTableCell: UITableViewCell {

    @IBOutlet weak var imPoster : UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    func bindView(_ item : ListMovies.FetchMovies.ViewModel.DisplayedMovie)  {
        let posterPath = item.posterPath

        imPoster.kf.setImage(with: URL(string: posterPath), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { result in
            switch result {
            case .success(let value):
                self.imPoster.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        })
        imPoster.superview?.clipsToBounds = true
        imPoster.clipsToBounds = true
        lblTitle.text = item.title
        lblDetail.text = item.overview
        lblDate.text = item.releaseDate
    }
}
