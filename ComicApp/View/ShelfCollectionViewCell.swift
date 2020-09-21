//
//  ShelfCollectionViewCell.swift
//  ComicApp
//
//  Created by Fernando de Lucas da Silva Gomes on 18/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfCollectionViewCell: UICollectionViewCell {
    
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
    }
        
        func setupConstraints() {
           imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }

}
