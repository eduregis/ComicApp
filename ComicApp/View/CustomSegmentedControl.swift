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
        UIView.animate(withDuration: 0.5, animations: {
                view.layoutIfNeeded() })
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
        
        guard let seg = self.titleForSegment(at: 0) else { return }
        
        segmentIndicator.widthAnchor.constraint(equalToConstant: CGFloat(15 + seg.count * 20)).isActive = true
        segmentIndicator.center = CGPoint(x: self.center.x/CGFloat(numberOfSegments), y: self.center.y)
        print(self.center.x/CGFloat(numberOfSegments))
    }
    
    func indexChanged(newIndex: Int) {
        
        configure()
        
        segmentIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        leading.isActive = false
        leading = segmentIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (UIScreen.main.bounds.width)/3 * CGFloat(newIndex))
        leading.isActive = true
        
        segmentIndicator.layoutIfNeeded()

    }

}
