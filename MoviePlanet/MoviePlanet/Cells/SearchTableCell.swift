//
//  SearchTableCell.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//


import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!

    func bindView(_ item : ListMovies.FetchSearchMovies.ViewModel.DisplayedMovie)  {
      lblTitle.text = item.title
    }
    
}
