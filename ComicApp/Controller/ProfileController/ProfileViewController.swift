//
//  ProfiileViewController.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileProgressView: ProfileProgress!
    
    let imagePicker = UIImagePickerController()
    
    var emptyState = EmptyState()
    
    var lastComics = Database.shared.loadRecentComics(limit: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        xibConfigure()
        setupLayout()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.sectionIndexColor = .clear
        tableView.backgroundColor = .clear
        
        self.imagePicker.delegate = self
        
        setButtonUserImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lastComics = Database.shared.loadRecentComics(limit: 5)
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()

        profileProgressView.readingLabel.text = "\(String(describing: Database.shared.loadData(from: .reading)!.count)) Lendo"
        profileProgressView.readLabel.text = "\(String(describing: Database.shared.loadData(from: .read)!.count)) Lido"
        profileProgressView.wantReadLabel.text = "\(String(describing: Database.shared.loadData(from: .wantToRead)!.count)) Quero ler"

        profileProgressView.progressReading.progress = Float(Database.shared.statusProgress(statusFrom: .reading))
        profileProgressView.progressRead.progress = Float(Database.shared.statusProgress(statusFrom: .read))
        profileProgressView.progressWantRead.progress = Float(Database.shared.statusProgress(statusFrom: .wantToRead))
        
        if let data = UserDefaults.standard.data(forKey: "userImage") {
            userImage.image = UIImage(data: data)
        }
        
        handleEmptyState()
    }

    func handleEmptyState() {
        if lastComics.count == 0 {
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
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
        
        if let imageData = lastComics[indexPath.section].image {
            cell.comicImage.image = UIImage(data: imageData)
        }
        cell.comicName.text = lastComics[indexPath.section].title
        cell.comicStatus.text = lastComics[indexPath.section].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lastComics.count
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
        
        editComicController.comic = lastComics[indexPath.section]
        navigationController?.pushViewController(editComicController, animated: true)
    }
}
