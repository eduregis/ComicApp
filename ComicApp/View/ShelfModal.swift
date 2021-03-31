//
//  ShelfModal.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 30/03/21.
//  Copyright © 2021 Eduardo Oliveira. All rights reserved.
//

import Foundation
import UIKit


protocol PopUpModalDelegate: AnyObject {
    func popUpModal(image: UIImage, comic: ComicCD)
    func removeModal()
}

class ShelfViewModal: UIView {
    
    var handleView: (() -> Void)?
    
    let blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: effect)
        return blurEffectView
    }()
    
    let imageForModal: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let lableForTitleInModal: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Teste"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let statusLabelModal: UILabel = {
        let statusLabel = UILabel()
        return statusLabel
    }()
    
    let progressViewModal: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()
    
    func setImageForModal(fromImage image: UIImage) {
        self.addSubview(imageForModal)
        imageForModal.image = image
        var aspectRatio: CGFloat = 0
        if image.size.width > image.size.height {
            aspectRatio = image.size.height/image.size.width
            if image.size.width > 300 {
                imageForModal.widthAnchor.constraint(equalToConstant: 300).isActive = true
            } else {
                imageForModal.widthAnchor.constraint(equalToConstant: image.size.height).isActive = true
            }
            imageForModal.heightAnchor.constraint(equalTo: imageForModal.widthAnchor, multiplier: aspectRatio).isActive = true
        } else if image.size.width == image.size.height {
            imageForModal.widthAnchor.constraint(equalToConstant: 300).isActive = true
            imageForModal.heightAnchor.constraint(equalToConstant: 300).isActive = true
        } else {
            aspectRatio = image.size.width/image.size.height
            if image.size.height > 300 {
                imageForModal.heightAnchor.constraint(equalToConstant: 300).isActive = true
            } else {
                imageForModal.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
            }
            imageForModal.widthAnchor.constraint(equalTo: imageForModal.heightAnchor, multiplier: aspectRatio).isActive = true
        }
        imageForModal.contentMode = .scaleAspectFit
        imageForModal.clipsToBounds = true
        imageForModal.translatesAutoresizingMaskIntoConstraints = false
        imageForModal.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageForModal.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageForModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        imageForModal.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.imageForModal.alpha = 1
            self.imageForModal.transform = CGAffineTransform.identity
        }) { _ in
            let gesture = UITapGestureRecognizer(target: ShelfViewController.self, action: #selector(ShelfViewController.executarSegue))
            self.imageForModal.addGestureRecognizer(gesture)
        }
    }
    
    func setBlurEffectView() {
//        navigationController?.navigationBar.alpha = 0.1
//        addButton.isEnabled = false
        blurEffectView.frame = self.frame
        self.addSubview(blurEffectView)
        blurEffectView.alpha = 1
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.removeModal))
        self.blurEffectView.addGestureRecognizer(gesture)
    }
    
    func setLableForTitleInModal(fromText: String) {
        self.addSubview(lableForTitleInModal)
        lableForTitleInModal.text = fromText
        lableForTitleInModal.translatesAutoresizingMaskIntoConstraints = false
        lableForTitleInModal.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lableForTitleInModal.bottomAnchor.constraint(equalTo: imageForModal.topAnchor, constant: -17).isActive = true
        lableForTitleInModal.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17).isActive = true
        lableForTitleInModal.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17).isActive = true
        lableForTitleInModal.alpha = 0
        lableForTitleInModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4) {
            self.lableForTitleInModal.alpha = 1
            self.lableForTitleInModal.transform = CGAffineTransform.identity
        }
    }
    
    func setStatusForModal(status: String, progress: Float, comicStatus: String) {
        self.addSubview(statusLabelModal)
        self.addSubview(progressViewModal)
        if comicStatus == "Lido"{
            self.progressViewModal.tintColor = .systemGreen
        } else {
            self.progressViewModal.tintColor = .systemBlue
        }
        statusLabelModal.text = status
        progressViewModal.setProgress(0, animated: true)
        statusLabelModal.translatesAutoresizingMaskIntoConstraints = false
        statusLabelModal.topAnchor.constraint(equalToSystemSpacingBelow: imageForModal.bottomAnchor, multiplier: 3).isActive = true
        statusLabelModal.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressViewModal.translatesAutoresizingMaskIntoConstraints = false
        progressViewModal.topAnchor.constraint(equalToSystemSpacingBelow: statusLabelModal.bottomAnchor, multiplier: 3).isActive = true
        progressViewModal.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressViewModal.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        progressViewModal.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.progressViewModal.setProgress(progress, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.statusLabelModal.alpha = 1
            self.progressViewModal.alpha = 1
        }
    }
    
}


extension ShelfViewModal: PopUpModalDelegate {
    
    func popUpModal(image: UIImage, comic: ComicCD) {
        handleView?()
        self.isHidden = false 
        setBlurEffectView()
        setImageForModal(fromImage: image)
        setLableForTitleInModal(fromText: comic.title!)
        let progressNumber = comic.progressNumber
        let finishNumber = comic.finishNumber
        if comic.status != "Quero Ler" {
            setStatusForModal(status: "\(progressNumber)/\(finishNumber)", progress: (Float(progressNumber)/Float(finishNumber)), comicStatus: comic.status!)
        }
    }
    
    @objc func removeModal() {
        UIView.animate(withDuration: 0.4, animations: {
            self.imageForModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.imageForModal.alpha = 0
            self.lableForTitleInModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.lableForTitleInModal.alpha = 0
            self.blurEffectView.alpha = 0
            self.statusLabelModal.alpha = 0
            self.progressViewModal.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
//        navigationController?.navigationBar.alpha = 1
//        addButton.isEnabled = true
    }
    
}
