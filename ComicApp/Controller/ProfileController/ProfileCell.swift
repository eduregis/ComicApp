//
//  ProfileCell.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = .red
    }

    /*
    func loadViewFromNib() -> UIView {
        let nib: UINib = UINib(nibName: "ProfileCell", bundle: .main)
        let view: UITableViewCell?
        view = nib.instantiate(withOwner: self, options: nil).last as? UITableViewCell ?? nil
        guard let viewProgress = view else {
            fatalError()
        }

        return viewProgress
    }
    */
}
