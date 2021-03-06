//
//  ProfileCell.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var comicName: UILabel!
    @IBOutlet weak var comicStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    func setupLayer() {
        comicName.tintColor = .systemRed
        comicName.adjustsFontSizeToFitWidth = true
        //comicName.minimumScaleFactor = 0.6
        comicImage.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2

        self.layer.masksToBounds = true
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10))
        
        self.backgroundColor = .systemGray6
    }

}
