//
//  MovieListViewController.swift
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

protocol MovieListDisplayLogic: class {
    func displayMovies(viewModel: ListMovies.FetchMovies.ViewModel)
    func displaySliderMovies(viewModel: ListMovies.FetchSlidersMovies.ViewModel)
    func displaySearchMovies(viewModel: ListMovies.FetchSearchMovies.ViewModel)
}

class MovieListViewController: UIViewController, MovieListDisplayLogic {
    @IBOutlet weak var mSearchBar : UISearchBar!
    @IBOutlet weak var sTableView: UITableView!
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var mTableView: UITableView!
    var isSearching = false
    var interactor: MovieListBusinessLogic?
    var router: (NSObjectProtocol & MovieListRoutingLogic & MovieListDataPassing)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = MovieListInteractor()
        let presenter = MovieListPresenter()
        let router = MovieListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            if let router = router {
                let sender = sender as! [String:Any]
                router.routeToShowMovieDetail(segue: segue,movieId: sender["movieId"] as! Int )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        fetchData()
    }
    
    fileprivate func setUpUI() {
        title = "Movie Planet"
        setUpTableView()
        setUpSearchView()
    }
        
    fileprivate func setUpTableView() {
        sTableView.register(SearchTableCell.self)
        sTableView.isHidden = true
    }
   
    fileprivate func setUpSearchView() {
        mSearchBar.placeholder = "Search"
        mTableView.register(MovieTableCell.self)
    }
    
    var upcomingDisplayedMovies : [ListMovies.FetchMovies.ViewModel.DisplayedMovie] = []
    var sliderDisplayedMovies : [ListMovies.FetchSlidersMovies.ViewModel.DisplayedMovie] = []
    var searchMovies : [ListMovies.FetchSearchMovies.ViewModel.DisplayedMovie] = []
    var pathArray : [String] = []
    var titleArray : [String] = []
    
    func fetchData() {
        fetchUpcomingList()
        fetchSliderMovies()
    }
    
    private func fetchUpcomingList() {
        let request = ListMovies.FetchMovies.Request()
        interactor?.fetchMovies(request: request)
    }
    
    private func fetchSliderMovies() {
        let request = ListMovies.FetchSlidersMovies.Request()
        interactor?.fetchSliderMovies(request: request)
    }
    
    private func fetchSearchMovies(keyword : String) {
        let request = ListMovies.FetchSearchMovies.Request()
        interactor?.fetchSearchMovies(keyword: keyword, request: request)
    }
    
    func displayMovies(viewModel: ListMovies.FetchMovies.ViewModel) {
        upcomingDisplayedMovies = viewModel.displayedMovie
        DispatchQueue.main.async {
            self.mTableView.reloadData()
        }
    }
    
    func displaySliderMovies(viewModel: ListMovies.FetchSlidersMovies.ViewModel) {
        sliderDisplayedMovies = viewModel.displayedMovie
        titleArray = viewModel.titleArray
        pathArray = viewModel.pathArray
        DispatchQueue.main.async {
            self.fillSlider()
        }
    }
    
    private func fillSlider() {
        carouselView.delegate = self
        carouselView.setCarouselData(paths: self.pathArray,  describedTitle: self.titleArray, isAutoScroll: true, timer: 5.0, defaultImage: "defaultImage")
        carouselView.setCarouselOpaque(layer: false, describedTitle: false, pageIndicator: false)
        carouselView.setCarouselLayout(displayStyle: 0, pageIndicatorPositon: 2, pageIndicatorColor: nil, describedTitleColor: nil, layerColor: nil)
    }
    
    func displaySearchMovies(viewModel: ListMovies.FetchSearchMovies.ViewModel) {
        searchMovies = viewModel.displayedMovie
        DispatchQueue.main.async {
            self.sTableView.isHidden = false
            self.sTableView.reloadData()
        }
    }
}

extension MovieListViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        sTableView.dataSource = nil
        isSearching = searchBar.text!.count > 2
        sTableView.dataSource = self
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        mSearchBar.text = ""
        mSearchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        mSearchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKeyword(searchText)
    }

    func searchKeyword(_ searchText : String) {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        isSearching = keyword.count > 2
        if keyword.count > 2 {
            fetchSearchMovies(keyword: keyword)
        } else {
            searchMovies.removeAll()
            sTableView.isHidden = true
            sTableView.reloadData()
            if keyword.isEmpty {
                mSearchBar.resignFirstResponder()
            }
        }
    }
}


extension MovieListViewController : AACarouselDelegate {
    
    func downloadImages(_ url: String, _ index:Int) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { result in
            switch result {
            case .success(let value):
                self.carouselView.images[index] = value.image
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        })
    }

    func didSelectCarouselView(_ view: AACarousel ,_ index:Int) {
        let movieId = sliderDisplayedMovies[index].id
        performSegue(withIdentifier: "goDetail", sender: ["movieId" : movieId])
    }

    func callBackFirstDisplayView(_ imageView: UIImageView, _ url: [String], _ index: Int) {
        imageView.kf.setImage(with: URL(string: url[index]), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
}

extension MovieListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.tag == 0 ? 50 : 130
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tableView.tag == 0 ? searchMovies.count :  upcomingDisplayedMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let item = searchMovies[indexPath.row]
            let cell = tableView.dequeueReusableCell(SearchTableCell.self)!
            cell.accessoryType = .disclosureIndicator
            cell.bindView(item)
            return cell
        } else {
            let item = upcomingDisplayedMovies[indexPath.row]
            let cell = tableView.dequeueReusableCell(MovieTableCell.self)!
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.bindView(item)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movieId : Int = 0
        if tableView.tag == 0 {
            movieId = searchMovies[indexPath.row].id
        } else {
            movieId = upcomingDisplayedMovies[indexPath.row].id
        }
        performSegue(withIdentifier: "goDetail", sender: ["movieId" : movieId ] )
    }
}
