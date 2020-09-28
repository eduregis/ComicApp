//
//  ProfiileViewController.swift
//  ComicApp
//
//  Created by Ronaldo Gomes on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lastComics = Database.shared.loadRecentComics(limit: 5)
        tableView.reloadData()
    }
    
    func xibConfigure() {
        let nib = UINib.init(nibName: "ProfileCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ProfileCell")
    }
    
    func setupLayout() {
        userImage.layer.cornerRadius = userImage.bounds.width / 2
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
}
