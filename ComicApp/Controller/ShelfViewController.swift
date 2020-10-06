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
    
    var emptyState = EmptyState()
    
    let comicCollectionView: UICollectionView = {
        let layout = ComicCustomLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ShelfCollectionViewCell.self, forCellWithReuseIdentifier: "ShelfCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var listOfComics: [Comic] = [] {
        didSet {
            DispatchQueue.main.async {
                self.comicCollectionView.reloadData()
                self.handleEmptyState()
            }
        }
    }
    
    let blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: effect)
        return blurEffectView
    }()
    
    let imageForModal: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let lableForTitleInModal: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Teste"
        return label
    }()
    
    let statusLabelModal: UILabel = {
        let statusLabel = UILabel()
        return statusLabel
    }()
    
    let progressViewModal: UIProgressView = {
        let progressView = UIProgressView()
        return progressView
    }()
    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Estante"
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
        loadListData()
        handleEmptyState()
    }
    
    func setCollectionView() {
        self.view.addSubview(comicCollectionView)
        comicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        comicCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: segmentedControl.bottomAnchor, multiplier: 3).isActive = true
        comicCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        comicCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        comicCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func handleEmptyState() {
        if listOfComics.count == 0 {
            setEmptyState()
        } else {
            emptyState.removeFromSuperview()
        }
    }
    
    func setEmptyState() {
        view.addSubview(emptyState)
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyState.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            emptyState.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setImageForModal(fromImage image: UIImage) {
        view.addSubview(imageForModal)
        imageForModal.image = image
        var aspectRatio: CGFloat = 0
        if image.size.width > image.size.height {
            aspectRatio = image.size.height/image.size.width
            if image.size.width > 300 {
                imageForModal.widthAnchor.constraint(equalToConstant: 300).isActive = true
            } else {
                imageForModal.widthAnchor.constraint(equalToConstant: image.size.height).isActive = true
            }
            imageForModal.heightAnchor.constraint(equalTo: imageForModal.widthAnchor, multiplier: aspectRatio).isActive = true
        } else if image.size.width == image.size.height {
            imageForModal.widthAnchor.constraint(equalToConstant: 300).isActive = true
            imageForModal.heightAnchor.constraint(equalToConstant: 300).isActive = true
        } else {
            aspectRatio = image.size.width/image.size.height
            if image.size.height > 300 {
                imageForModal.heightAnchor.constraint(equalToConstant: 300).isActive = true
            } else {
                imageForModal.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
            }
            imageForModal.widthAnchor.constraint(equalTo: imageForModal.heightAnchor, multiplier: aspectRatio).isActive = true
        }
        imageForModal.contentMode = .scaleAspectFit
        imageForModal.clipsToBounds = true
        imageForModal.translatesAutoresizingMaskIntoConstraints = false
        imageForModal.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageForModal.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageForModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        imageForModal.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.imageForModal.alpha = 1
            self.imageForModal.transform = CGAffineTransform.identity
        }) { _ in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.executarSegue))
            self.imageForModal.addGestureRecognizer(gesture)
        }
    }
    
    func setBlurEffectView() {
        blurEffectView.frame = view.frame
        self.view.addSubview(blurEffectView)
        blurEffectView.alpha = 1
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.removeModal))
        self.blurEffectView.addGestureRecognizer(gesture)
    }
    
    func setLableForTitleInModal(fromText: String) {
        view.addSubview(lableForTitleInModal)
        lableForTitleInModal.text = fromText
        lableForTitleInModal.translatesAutoresizingMaskIntoConstraints = false
        lableForTitleInModal.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true 
        lableForTitleInModal.bottomAnchor.constraint(equalTo: imageForModal.topAnchor, constant: -17).isActive = true
        lableForTitleInModal.alpha = 0
        lableForTitleInModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4) {
            self.lableForTitleInModal.alpha = 1
            self.lableForTitleInModal.transform = CGAffineTransform.identity
        }
    }
    
    func setStatusForModal(status: String, progress: Float, comicStatus: String) {
        view.addSubview(statusLabelModal)
        view.addSubview(progressViewModal)
        if comicStatus == "Lido"{
            self.progressViewModal.tintColor = .systemGreen
        } else {
            self.progressViewModal.tintColor = .systemBlue
        }
        statusLabelModal.text = status
        progressViewModal.setProgress(0, animated: true)
        statusLabelModal.translatesAutoresizingMaskIntoConstraints = false
        statusLabelModal.topAnchor.constraint(equalToSystemSpacingBelow: imageForModal.bottomAnchor, multiplier: 3).isActive = true
        statusLabelModal.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        progressViewModal.translatesAutoresizingMaskIntoConstraints = false
        progressViewModal.topAnchor.constraint(equalToSystemSpacingBelow: statusLabelModal.bottomAnchor, multiplier: 3).isActive = true
        progressViewModal.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        progressViewModal.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        progressViewModal.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.progressViewModal.setProgress(progress, animated: true)
        UIView.animate(withDuration: 0.4) {
            self.statusLabelModal.alpha = 1
            self.progressViewModal.alpha = 1
        }
    }
    
    @objc func removeModal() {
        UIView.animate(withDuration: 0.4, animations: {
            self.imageForModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.imageForModal.alpha = 0
            self.lableForTitleInModal.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.lableForTitleInModal.alpha = 0
            self.blurEffectView.alpha = 0
            self.statusLabelModal.alpha = 0
            self.progressViewModal.alpha = 0
        }) { _ in
            self.imageForModal.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            self.imageForModal.removeConstraints(self.imageForModal.constraints)
            self.lableForTitleInModal.removeFromSuperview()
            self.statusLabelModal.removeFromSuperview()
            self.progressViewModal.removeFromSuperview()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditComicViewController {
            let tableVC = segue.destination as? EditComicViewController
            tableVC?.comic = selectedComic
        }
    }
    
    @objc func executarSegue() {
        performSegue(withIdentifier: "EditComicSegue", sender: self)
        removeModal()
    }
    
}

extension ShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = comicCollectionView.dequeueReusableCell(withReuseIdentifier: "ShelfCell", for: indexPath) as? ShelfCollectionViewCell else {
            fatalError()
        }
        cell.configCell(from: listOfComics[indexPath.row])
        cell.delegate = self
        return cell
    }
}
