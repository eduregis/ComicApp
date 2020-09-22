//
//  ShelfCollectionViewCell.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 18/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.setProgress(1, animated: true)
        progressView.trackTintColor = .clear
        progressView.tintColor = .systemBlue
        return progressView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func configImage(image: String) {
        self.imageView.image = UIImage(named: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
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
        progressView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        progressView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
    }
    
}
