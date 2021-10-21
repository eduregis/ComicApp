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
    
    weak var modalDelegate: PopUpModalDelegate?
    
    var selectedComic: ComicCD?
    
    var emptyState = EmptyState()
        
    let comicCollectionView: UICollectionView = {
        let collectionView = ShelfCollection(with: ComicCustomLayout())
        return collectionView
    }()
    
    lazy var viewModel: ShelfViewModel = { [unowned self] in
        let model = ShelfViewModel(status: "Lendo", controller: self)
        return model
    }()
    
    let modalPopUp: ShelfViewModal = {
        let modal = ShelfViewModal()
        modal.translatesAutoresizingMaskIntoConstraints = false
        return modal
    }()

    @IBOutlet weak var segmentedControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        comicCollectionView.delegate = self
        comicCollectionView.dataSource = self
        viewModel.handleTransition = { [weak self] in
            DispatchQueue.main.async {
                self?.comicCollectionView.reloadData()
                self?.handleEmptyState()
            }
        }
        modalPopUp.handleView = { [unowned self] in
            if !(self.modalPopUp.isDescendant(of: self.view)) {self.setModal()}
        }
        setCollectionView()
        setModal()
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
    
    func setModal() {
        self.view.addSubview(modalPopUp)
        modalPopUp.isHidden = true 
        NSLayoutConstraint.activate([
            modalPopUp.topAnchor.constraint(equalTo: self.view.topAnchor),
            modalPopUp.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            modalPopUp.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            modalPopUp.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
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
        if viewModel.numberOfComics == 0 {
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
    
    @IBAction func addToSheftButton(_ sender: Any) {
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
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
            viewModel.status = "Lendo"
        case 1:
            viewModel.status = "Lido"
        case 2:
            viewModel.status = "Quero Ler"
        default:
            viewModel.status = "Lendo"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditComicViewController {
            let tableVC = segue.destination as? EditComicViewController
        }
    }
    
    @objc func executarSegue() {
        performSegue(withIdentifier: "EditComicSegue", sender: self)
        modalDelegate?.removeModal()
    }
    
}

extension ShelfViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfComics
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = comicCollectionView.dequeueReusableCell(withReuseIdentifier: "ShelfCell", for: indexPath) as? ShelfCollectionViewCell else {
            fatalError()
        }
        guard let comic = viewModel.comicForRow(at: indexPath) else {return ShelfCollectionViewCell()}
        cell.configCell(from: comic)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = viewModel.comicForRow(at: indexPath) else {return}
        guard let data = comic.image else {return}
        modalDelegate = modalPopUp
        let image = UIImage(data: data)
        modalDelegate?.popUpModal(image: image!, comic: comic)
        self.selectedComic = comic
    }
}

extension ShelfViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.comicCollectionView.reloadData()
    }
}
