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
    
    let lastComics = Database.shared.loadRecentComics(limit: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        xibConfigure()
        setupLayout()
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
        
        cell.comicImage.image = UIImage(named: lastComics[indexPath.row].imageURL ?? "")
        cell.comicName.text = lastComics[indexPath.row].title
        cell.comicStatus.text = lastComics[indexPath.row].status
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastComics.count
    }
}
