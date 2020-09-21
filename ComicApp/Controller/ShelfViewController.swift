//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {
    
    let comicCollectionView: UICollectionView = {
        let layout = ComicCustomLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShelfCollectionViewCell.self, forCellWithReuseIdentifier: "ShelfCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var listOfComics: [Comic] = [] {
        didSet {
            DispatchQueue.main.async {
                self.comicCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileHandler()
        self.title = "Minha Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        setCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for subview in segmentedControl.subviews {
            if !subview.responds(to: #selector(setter: UITabBarItem.badgeValue)), subview.subviews.count == 1 {
                subview.isHidden = true
            }
        }
    }
    
    func setCollectionView() {
           self.view.addSubview(comicCollectionView)
           comicCollectionView.translatesAutoresizingMaskIntoConstraints = false
           comicCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.topAnchor, multiplier: 20).isActive = true
            comicCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
           comicCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17).isActive = true
            comicCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
       }
       
    @IBAction func addToSheftButton(_ sender: Any) {
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
    }
    
    func fileHandler() {
        guard let list = Database.shared.loadData(from: .read) else {
            fatalError()
        }
        listOfComics = list
    }
    
    @IBAction func indexChanged(_ sender: CustomSegmentedControl) {
        segmentedControl.indexChanged(newIndex: sender.selectedSegmentIndex)
    }
    
}

extension ShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listOfComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = comicCollectionView.dequeueReusableCell(withReuseIdentifier: "ShelfCell", for: indexPath) as? ShelfCollectionViewCell else {
            fatalError()
        }
        if let imageUrl = listOfComics[indexPath.row].imageURL {
            cell.configImage(image: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditComicSegue", sender: self)
    }
    
}
