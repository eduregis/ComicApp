//
//  CustomSegmentedControl.swift
//  ComicApp
//
//  Created by Nathalia Cardoso on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    
    var leading = NSLayoutConstraint()
    
    let segmentIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemPink
        return view
    }()
    
    var color = UIColor.systemBlue
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        self.addSubview(segmentIndicator)
        setUpSegmentedIndicatorConstraints()
    }
    
    private func configure() {
        self.selectedSegmentTintColor = .clear
        
        switch self.selectedSegmentIndex {
        case 0:
            color = UIColor.systemBlue
        case 1:
            color = UIColor.systemGreen
        case 2:
            color = UIColor.systemOrange
        default:
            color = UIColor.systemBlue
        }
        
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: UIControl.State.selected)
        segmentIndicator.backgroundColor = color
        
    }
    
    func setUpSegmentedIndicatorConstraints() {
        segmentIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        segmentIndicator.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        segmentIndicator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        leading.isActive = false
        leading = segmentIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (((UIScreen.main.bounds.width)/3) * CGFloat(self.selectedSegmentIndex))+(20/2))
        leading.isActive = true

        segmentIndicator.widthAnchor.constraint(equalToConstant: CGFloat((UIScreen.main.bounds.width)/3)-20).isActive = true
    }
    
    func indexChanged(newIndex: Int) {
        
        segmentIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        leading.isActive = false
        leading = segmentIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (((UIScreen.main.bounds.width)/3) * CGFloat(newIndex))+(20/2))
        leading.isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded() })
        configure()
    }

}
