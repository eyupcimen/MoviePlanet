//
//  Util.swift
//  MoviePlanet
//
//  Created by eyup cimen on 23.09.2021.
//

import Foundation
import UIKit
import ASProgressHud

class Util {
    static var shared = Util()
    func encodeUrl(_ url : String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func showHud() {
        removeHud()
        DispatchQueue.main.async {
            let view = mainDelegate.window!
            let show = ASProgressHud.showHUDAddedTo(view, animated: true, type: .default)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissLoading))
            show.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissLoading(recognizer: UITapGestureRecognizer) {
        removeHud()
    }
    
    func removeHud() {
        let view = mainDelegate.window!
        DispatchQueue.main.async {
            _ = ASProgressHud.hideAllHUDsForView(view, animated: true)
        }
    }
}
