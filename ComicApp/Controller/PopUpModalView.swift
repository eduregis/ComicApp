//
//  PopUpModalView.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 22/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

extension ShelfViewController: PopUpModalDelegate {
    func popUpModal(image: UIImage) {
        blurEffectView.frame = view.frame
        let gesture = UITapGestureRecognizer(target: self, action: #selector(removeModal))
        blurEffectView.addGestureRecognizer(gesture)
        self.view.addSubview(blurEffectView)
        blurEffectView.alpha = 1
        setImageForModal(fromImage: image)
        setLableForTitleInModal(fromText: "Teste")
    }
}
