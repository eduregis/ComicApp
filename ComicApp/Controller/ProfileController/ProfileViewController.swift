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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        xibConfigure()
    }
    
    func xibConfigure() {
        let nib = UINib.init(nibName: "ProfileCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ProfileCell")
    }

}

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
}
