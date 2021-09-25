//
//  SubCollectionView.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import UIKit

class SubCollectionView : UICollectionView {

    var items : [MovieDetail.SimilarMovies.ViewModel.DisplayedMovie] = [MovieDetail.SimilarMovies.ViewModel.DisplayedMovie]()
    
    var cellSizeW : CGFloat = 0
    var cellSizeH : CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        self.collectionViewLayout = layout

        self.delegate   = self
        self.dataSource = self

        let w = (UIScreen.main.bounds.width - 1) / 4

        cellSizeW = w
        cellSizeH = self.frame.size.height - 20
    }
}

extension SubCollectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(MovieCollectionViewCell.self, indexPath)!
        cell.bindView(item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: cellSizeW, height: cellSizeH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
