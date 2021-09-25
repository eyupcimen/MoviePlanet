//
//  Extensions.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//


import Foundation
import UIKit


extension UITableView {
    func register(_ type : UITableViewCell.Type) {
        let className = String(describing: type)
        self.register(UINib(nibName: className , bundle: nil), forCellReuseIdentifier: className)
    }

    func dequeueReusableCell<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className) as? T
    }
}

extension UICollectionView {
    func register(_ type : UICollectionViewCell.Type) {
        let className = String(describing: type)
        self.register(UINib(nibName: className , bundle: nil), forCellWithReuseIdentifier: className)
    }

    func dequeueReusableCell<T>(_ type : T.Type, _ row : IndexPath) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withReuseIdentifier: className, for: row) as? T
    }
}
