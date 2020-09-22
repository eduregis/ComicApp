//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {
    
    var selectedComic: Comic?
    var selectedIndex: Int?
    
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
//                print(Database.shared.loadData(from: .wantToRead)?.count)
//                print(Database.shared.loadData(from: .read)?.count)
//                print(Database.shared.loadData(from: .reading)?.count)
                self.listOfComics.forEach {
                    print($0.title)
                }
            }
        }
    }
    
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.shared.mocking()
        self.title = "Minha Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        //fileHandler(statusType: .reading)
        setCollectionView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for subview in segmentedControl.subviews {
            if !subview.responds(to: #selector(setter: UITabBarItem.badgeValue)), subview.subviews.count == 1 {
                subview.isHidden = true
            }
        }
        loadListData()
    }
    
    func setCollectionView() {
        
        self.view.addSubview(comicCollectionView)
        comicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        comicCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: segmentedControl.bottomAnchor, multiplier: 3).isActive = true
        comicCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        comicCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17).isActive = true
        comicCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @IBAction func addToSheftButton(_ sender: Any) {
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
    }
    
    func fileHandler(statusType: StatusType) {
        guard let list = Database.shared.loadData(from: statusType) else {
            fatalError()
        }
        listOfComics = list
    }
    
    @IBAction func indexChanged(_ sender: CustomSegmentedControl) {
        segmentedControl.indexChanged(newIndex: sender.selectedSegmentIndex)
        switchData(sender: sender)
    }
    
    func switchData(sender: CustomSegmentedControl) {
        loadListData()
    }
    
    func loadListData () {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fileHandler(statusType: .reading)
        case 1:
            fileHandler(statusType: .read)
        case 2:
            fileHandler(statusType: .wantToRead)
        default:
            fileHandler(statusType: .reading)
        }
    }
    
    func animateCell(progressView: UIProgressView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 2) {
                progressView.setProgress(1, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditComicViewController {
            let tableVC = segue.destination as? EditComicViewController
            tableVC?.comic = selectedComic
            tableVC?.oldIndex = selectedIndex
        }
    }
    
}

extension ShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listOfComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = comicCollectionView.dequeueReusableCell(withReuseIdentifier: "ShelfCell", for: indexPath) as? ShelfCollectionViewCell else {
            fatalError()
        }
        if let imageUrl = listOfComics[indexPath.row].imageURL {
            cell.configImage(image: imageUrl)
            animateCell(progressView: cell.progressView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedComic = listOfComics[indexPath.row]
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "EditComicSegue", sender: self)
    }
}
