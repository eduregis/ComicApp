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
    
    @IBOutlet weak var readingNumber: UILabel!
    
    @IBOutlet weak var readNumber: UILabel!
    
    @IBOutlet weak var wantReadNumber: UILabel!
    
    @IBOutlet weak var statusComic: UIStackView!
    
    
    var progressWantRead: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 1.0
        progress.progressTintColor = .orange
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    var progressRead: UIProgressView = {
        let progress = UIProgressView()
        //progress.progress = Float(statusReadingProgress())
        progress.progress = Float(Database.shared.statusProgress(statusFrom: .read))
        progress.progressTintColor = .blue
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    var progressReading: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = Float(Database.shared.statusProgress(statusFrom: .reading))
        progress.progressTintColor = .green
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    override func draw(_ rect: CGRect) {
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
        
        constraintsProgress(progress: progressWantRead)
        constraintsProgress(progress: progressRead)
        constraintsProgress(progress: progressReading)
        setupLayout()
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
            progress.topAnchor.constraint(equalTo:
                self.readingNumber.bottomAnchor, constant: 5),
            progress.leadingAnchor.constraint(equalTo:
                self.viewXib.leadingAnchor, constant: 20),
            progress.trailingAnchor.constraint(equalTo:
                self.viewXib.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLayout() {
        readNumber.text = Database.shared.loadData(from: .read)?.count.description
        readingNumber.text = Database.shared.loadData(from: .reading)?.count.description
        wantReadNumber.text = Database.shared.loadData(from: .wantToRead)?.count.description
    }
}
