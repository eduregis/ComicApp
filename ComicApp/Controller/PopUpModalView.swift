//
//  PopUpModalView.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 22/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

extension ShelfViewController: PopUpModalDelegate {
    
    func popUpModal(image: UIImage, comic: Comic) {
        self.selectedComic = comic
        prepareForTransition()
        setBlurEffectView()
        setImageForModal(fromImage: image)
        setLableForTitleInModal(fromText: comic.title)
        if let progressNumber = comic.progressNumber, let finishNumber = comic.finishNumber {
            setStatusForModal(status: "\(progressNumber)/\(finishNumber)", progress: (Float(progressNumber)/Float(finishNumber)))
        }
    }
    
     func prepareForTransition() {
         if let comic = self.selectedComic {
            // self.selectedIndex = listOfComics.firstIndex(of: comic)
         }
     }
    
}
