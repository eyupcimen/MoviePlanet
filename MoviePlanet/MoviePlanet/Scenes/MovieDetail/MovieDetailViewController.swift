//
//  MovieDetailViewController.swift
//  MoviePlanet
//
//  Created by eyup cimen on 25.09.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MovieDetailDisplayLogic: class {
    func displayMovieDetail(viewModel: MovieDetail.Detail.ViewModel)
    func displaySimilarMovies(viewModel: MovieDetail.SimilarMovies.ViewModel)
}

class MovieDetailViewController: UIViewController, MovieDetailDisplayLogic {
    @IBOutlet weak var imPoster : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtDetail : UITextView!
    @IBOutlet weak var lblAverage : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var mCollectionView : SubCollectionView!
    
    var interactor: MovieDetailBusinessLogic?
    var router: (NSObjectProtocol & MovieDetailRoutingLogic & MovieDetailDataPassing)?
    
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
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        let router = MovieDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    fileprivate func fetchData () {
        fetchMovieDetail()
        fetchSimilarMovies()
    }
    
    fileprivate func setUpUI() {
        title = "Movie Planet"
        mCollectionView.register(MovieCollectionViewCell.self)
    }
    
    var similarDisplayedMovies : [MovieDetail.SimilarMovies.ViewModel.DisplayedMovie] = []
    
    func fetchMovieDetail() {
        guard let router = self.router, let dataStore = router.dataStore, let movieId = dataStore.movieId else {return}
        let request = MovieDetail.Detail.Request(movieId: movieId ) 
        interactor?.getMovieDetail(request: request)
    }
    
    func displayMovieDetail(viewModel: MovieDetail.Detail.ViewModel) {
        DispatchQueue.main.async {
            self.title = viewModel.displayedMovie.title
            self.lblTitle.text = viewModel.displayedMovie.title
            self.txtDetail.text = viewModel.displayedMovie.overview
            self.lblDate.text = viewModel.displayedMovie.releaseDate
            self.lblAverage.text = String(viewModel.displayedMovie.voteAverage)
            self.imPoster.kf.setImage(with: URL(string: viewModel.displayedMovie.backdropPath), placeholder: UIImage.init(named: "defaultImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    private func fetchSimilarMovies() {
        guard let router = self.router, let dataStore = router.dataStore, let movieId = dataStore.movieId else {return}
        let request = MovieDetail.SimilarMovies.Request(movieId: movieId)
        interactor?.getSimilarMovies(request: request)
    }
    
    func displaySimilarMovies(viewModel: MovieDetail.SimilarMovies.ViewModel) {
        similarDisplayedMovies = viewModel.displayedMovie
        DispatchQueue.main.async {    
            self.mCollectionView.items = self.similarDisplayedMovies
            self.mCollectionView.reloadData()
        }
    }
    
    @IBAction func goIMDB() {
        guard let router = self.router, let dataStore = router.dataStore, let movie = dataStore.movie else {return}
        guard let url = URL(string: movie.ImdbLink ?? "" ) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}