//
//  ProfileProgress.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileProgress: UIView {

    @IBOutlet weak var yourCollectionLabel: UILabel!
    @IBOutlet var viewXib: UIView!
    @IBOutlet weak var statusComic: UIStackView!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var wantReadLabel: UILabel!
    
    var progressWantRead: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .systemOrange
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 3)
        return progress
    }()
    
    var progressRead: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .systemGreen
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 3)
        return progress
    }()
    
    var progressReading: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 3)
        return progress
    }()
    
    override func draw(_ rect: CGRect) {
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
        //setupLayout()
        
        constraintsProgress(progress: progressWantRead)
        constraintsProgress(progress: progressRead)
        constraintsProgress(progress: progressReading)
    }
    
    func setupXib() {
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

    func constraintsProgress(progress: UIProgressView) {
        self.viewXib.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progress.bottomAnchor.constraint(equalTo:
                self.statusComic.topAnchor, constant: -30),
            //progress.topAnchor.constraint(equalTo:
            //    self.readingNumber.bottomAnchor, constant: 5),
            progress.leadingAnchor.constraint(equalTo:
                self.viewXib.leadingAnchor, constant: 20),
            progress.trailingAnchor.constraint(equalTo:
                self.viewXib.trailingAnchor, constant: -20)
        ])
    }
}
