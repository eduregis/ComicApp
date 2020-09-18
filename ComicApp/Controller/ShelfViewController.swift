//
//  ShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Minha Estante"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToSheftButton(_ sender: Any) {
        let test = Database.shared.loadData(from: .wantToRead)
        performSegue(withIdentifier: "AddToShelfSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
