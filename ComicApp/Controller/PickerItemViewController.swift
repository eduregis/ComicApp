//
//  PickerItemViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class PickerItemViewController: UITableViewController {

    var pickerFieldName: String?
    var pickerData: [String]?
    
    var delegate: ModalDelegate?
    
    var checkmark: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch pickerFieldName {
        case "Type":
            self.title = "Tipo"
        case "OrganizeBy":
            self.title = "Organizar por"
        case "Status":
            self.title = "Status"
        default:
            break
        }
       
        tableView.tableFooterView = UIView()
    }

    @IBAction func dismissViewController(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.changeValue(value: checkmark)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pickerData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setData", for: indexPath)
        cell.textLabel?.text = pickerData?[indexPath.row]
        if indexPath.row == checkmark {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkmark = indexPath.row
        tableView.reloadData()
    }
}
