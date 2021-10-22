//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ShelfViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    lazy var segmentedControl: CustomSegmentedControl = {
        let segmentedControl = CustomSegmentedControl()
        segmentedControl.backgroundColor = .clear
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()

    var mainView = ShelfView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.buildHierarchy()
        self.setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for subview in segmentedControl.subviews {
            if !subview.responds(to: #selector(setter: UITabBarItem.badgeValue)), subview.subviews.count == 1 {
                subview.isHidden = true
            }
        }
    }
    
    func buildHierarchy() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(mainView)
    }
    
    @IBAction func addToSheftButton(_ sender: Any) {
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
    }
    
    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentedControl.indexChanged(newIndex: sender.selectedSegmentIndex)
    }
    
    func setupConstraints() {
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.segmentedControl.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
        self.mainView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor).isActive = true
        self.mainView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditComicViewController {
            let tableVC = segue.destination as? EditComicViewController
        }
    }
    
    @objc func executarSegue() {
        performSegue(withIdentifier: "EditComicSegue", sender: self)
        mainView.modalDelegate?.removeModal()
    }
    
}
