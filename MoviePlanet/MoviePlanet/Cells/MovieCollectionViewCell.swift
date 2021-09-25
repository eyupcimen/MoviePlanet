//
//  MovieCollectionViewCell.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//


import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imPoster : UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func bindView(_ item : MovieDetail.SimilarMovies.ViewModel.DisplayedMovie)  {
        imPoster.kf.setImage(with: URL(string: item.posterPath), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))] , progressBlock: nil, completionHandler: nil)
        imPoster.clipsToBounds = true
        lblTitle.text = item.title
    }
}
