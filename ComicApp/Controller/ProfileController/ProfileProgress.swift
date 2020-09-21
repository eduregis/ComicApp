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
    
    var numberOfReading: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGreen
        label.text = Database.shared.loadData(from: .reading)?.count.description
        return label
    }()
    
    var numberOfRead: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemBlue
        label.text = Database.shared.loadData(from: .read)?.count.description
        return label
    }()
    
    var numberOfWantRead: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemOrange
        label.text = Database.shared.loadData(from: .wantToRead)?.count.description
        return label
    }()

    var progressWantRead: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 1.0
        progress.progressTintColor = .systemOrange
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    var progressRead: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = Float(Database.shared.statusProgress(statusFrom: .read))
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    var progressReading: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = Float(Database.shared.statusProgress(statusFrom: .reading))
        progress.progressTintColor = .systemGreen
        progress.trackTintColor = .clear
        progress.transform = progress.transform.scaledBy(x: 1, y: 2)
        return progress
    }()
    
    override func draw(_ rect: CGRect) {
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
        //setupLayout()
        
        constraintsLabel(statusType: .reading, comicLabel: numberOfReading)
        constraintsLabel(statusType: .read, comicLabel: numberOfRead)
        constraintsLabel(statusType: .wantToRead, comicLabel: numberOfWantRead)
        
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
    
    func constraintsLabel(statusType: StatusType, comicLabel: UILabel) {
        self.viewXib.addSubview(comicLabel)
        comicLabel.translatesAutoresizingMaskIntoConstraints = false
        
        comicLabel.topAnchor.constraint(equalTo: self.yourCollectionLabel.bottomAnchor, constant: 15).isActive = true
        
        let posicionScreen = setupPosicionOfScreen(statusOf: statusType) + 20
        comicLabel.leadingAnchor.constraint(equalTo: self.viewXib.leadingAnchor, constant: posicionScreen).isActive = true
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
    
    func setupPosicionOfScreen(statusOf: StatusType) -> CGFloat {
        let sizeOfProgress = Double(UIScreen.main.bounds.width - 40)
        let statusProgress = Database.shared.statusProgress(statusFrom: statusOf)
        let labelPosition =  (sizeOfProgress * statusProgress / 2)
        
        let posictionOnScreen: CGFloat
        switch statusOf {
        case .reading:
            posictionOnScreen = CGFloat(labelPosition)
        case .read:
            posictionOnScreen = CGFloat(labelPosition) + setupPosicionOfScreen(statusOf: .reading)
        case .wantToRead:
            posictionOnScreen = CGFloat(labelPosition) + ((setupPosicionOfScreen(statusOf: .reading) + setupPosicionOfScreen(statusOf: .read) ) / 2)
        }
        
        return posictionOnScreen
    }
}
