//
//  ShelfCollectionViewCell.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 18/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {

    weak var delegate: PopUpModalDelegate?
    
    var comic: Comic?
    var imageForCell: UIImage?
    var gesture : UITapGestureRecognizer?
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.setProgress(0, animated: true)
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    func configCell(from: Comic) {
        if let image = from.imageURL {
        self.imageView.image = UIImage(named: image)
            self.imageForCell = UIImage(named: image)
        }
        if from.status == "Lendo"{
            self.progressView.tintColor = .blue
            animateCell(progressView: self.progressView, progress: 1)
        }
        if from.status == "Lido"{
            self.progressView.setProgress(1, animated: false)
            self.progressView.tintColor = .green
        }
        
        if from.status == "Quero Ler"{
            self.progressView.setProgress(0, animated: false)
        }
        self.comic = from
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        gesture = UITapGestureRecognizer(target: self, action: #selector(openModal))
        self.addGestureRecognizer(gesture!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.center = self.center
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        self.addSubview(progressView)
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        progressView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        }
    
    func animateCell(progressView: UIProgressView, progress: Float) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
            progressView.setProgress(progress, animated: true)
            }
        }
    }
    
    @objc func openModal() {
        if let image = self.imageForCell, let comic = self.comic{
                      delegate?.popUpModal(image: image, comic: comic)
        }
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
}

protocol PopUpModalDelegate: AnyObject {
    func popUpModal(image: UIImage, comic: Comic)
}
