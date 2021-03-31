//
//  ProfiileViewController.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ProfileView: UIViewController, UIImagePickerControllerDelegate, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileProgressView: ProfileProgress!
    
    let imagePicker = UIImagePickerController()
    
    var emptyState = EmptyState()
    
    //var lastComics = Database.shared.loadRecentComics(limit: 5)
    
    //Core data
    lazy var coreData = CoreDataManager(controller: self)
    
    var lastComics: [ComicCD]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        xibConfigure()
        setupLayout()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.sectionIndexColor = .clear
        tableView.backgroundColor = .clear
        
        lastComics = coreData.loadRecentComics(limit: 5)
        
        self.imagePicker.delegate = self
        
        setButtonUserImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lastComics = coreData.loadRecentComics(limit: 5)
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()

        profileProgressView.readingLabel.text = "\(String(describing: coreData.fetchBy(by: "Lendo")!.count)) Lendo"
        profileProgressView.readLabel.text = "\(String(describing: coreData.fetchBy(by: "Lido")!.count)) Lido"
        profileProgressView.wantReadLabel.text = "\(String(describing: coreData.fetchBy(by: "Quero ler")!.count)) Quero ler"

        profileProgressView.progressReading.progress = Float(coreData.statusProgress(status: .reading))
        profileProgressView.progressRead.progress = Float(coreData.statusProgress(status: .read))
        profileProgressView.progressWantRead.progress = Float(coreData.statusProgress(status: .wantToRead))
        
        if let data = UserDefaults.standard.data(forKey: "userImage") {
            userImage.image = UIImage(data: data)
        }
        
        handleEmptyState()
    }

    func handleEmptyState() {
        if lastComics?.count == 0 {
            setEmptyState()
        } else {
            emptyState.removeFromSuperview()
        }
    }
    
    func setEmptyState() {
        view.addSubview(emptyState)
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyState.topAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -100),
            emptyState.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        emptyState.descriptionLabel.text = ""
    }
    
    func xibConfigure() {
        let nib = UINib.init(nibName: "ProfileCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ProfileCell")
    }
    
    func setupLayout() {
        userImage.layer.cornerRadius = userImage.bounds.width / 2
    }
    
    func setButtonUserImage() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
        userImage.addGestureRecognizer(gesture)
    }
    
    @objc func buttonAction() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if var image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = image.fixOrientation()
            if let data = image.pngData() {
                userImage.image = UIImage(data: data)
                UserDefaults.standard.set(data, forKey: "userImage")
            }
        }
        dismiss(animated: true, completion: nil)
    }

}

extension ProfileView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell else {
            fatalError()
        }
        
        if let imageData = lastComics![indexPath.section].image {
            cell.comicImage.image = UIImage(data: imageData)
        } else {
            let viewPlaceholder = UIView(frame: cell.comicImage.frame)
            viewPlaceholder.backgroundColor = UIColor(named: lastComics![indexPath.section].color ?? "Pink")
            cell.comicImage.image = viewPlaceholder.asImage()
        }
        cell.comicName.text = lastComics![indexPath.section].title
        cell.comicStatus.text = lastComics![indexPath.section].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lastComics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editComicController = UIStoryboard(name: "EditComic", bundle: nil).instantiateInitialViewController() as? EditComicViewController else {
            fatalError("Unexpected Error; \(String(describing: Error.self))")
        }
        
        //Enviar o Comic para o edit?
        //editComicController.comic = lastComics[indexPath.section]
        navigationController?.pushViewController(editComicController, animated: true)
    }
}
