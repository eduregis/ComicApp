//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Minha Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
    }
    override func viewDidAppear(_ animated: Bool) {
        for subview in segmentedControl.subviews {
            if !subview.responds(to: #selector(setter: UITabBarItem.badgeValue)), subview.subviews.count == 1 {
                subview.isHidden = true
            }
        }
    }
    
    @IBAction func indexChanged(_ sender: CustomSegmentedControl) {
        segmentedControl.indexChanged(newIndex: sender.selectedSegmentIndex)
    }

    @IBAction func addToSheftButton(_ sender: Any) {
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
    }

}
