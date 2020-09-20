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
    }

}
