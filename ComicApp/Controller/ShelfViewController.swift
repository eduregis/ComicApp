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
    
    let teste: UIView = {
        let vis = UIView()
        vis.backgroundColor = .red
        return vis
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        fileHandler()
        self.title = "Minha Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        setCollectionView()
        setView()
    }
    
    func setView() {
        self.view.addSubview(teste)
        teste.translatesAutoresizingMaskIntoConstraints = false
        teste.widthAnchor.constraint(equalToConstant: 100).isActive = true
        teste.heightAnchor.constraint(equalToConstant: 100).isActive = true
        teste.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: (UIScreen.main.bounds.width)/3 * 2).isActive = true
        teste.removeConstraints(teste.constraints)
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
    
}
