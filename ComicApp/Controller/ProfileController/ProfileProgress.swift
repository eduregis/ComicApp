//
//  ProfileProgress.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileProgress: UIView {

    @IBOutlet var viewXib: UIView!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /*
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
        setup()
    }
    */
    
    func setup() {
        self.viewXib = self.loadViewFromNib()
        self.viewXib.frame = bounds
        self.addSubview(self.viewXib)

    }

    func loadViewFromNib() -> UIView {
        let nib: UINib = UINib(nibName: "ProfileProgress", bundle: .main)
        let view: UIView?
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? nil
        guard let viewProgress = view else {
            fatalError()
        }

        return viewProgress
    }
}
