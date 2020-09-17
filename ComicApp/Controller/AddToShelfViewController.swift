//
//  AddToShelfViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 16/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

protocol ModalDelegate {
    func changeValue(value: Int)
}

class AddToShelfViewController: UITableViewController {
    
    var checkmark = 0
    
    var comicTitle: String?
    var imageURL: String?
    var progressNumber: Int?
    var finishNumber: Int?
    var type: String?
    var organizeBy: String?
    var status: String?
    var author: String?
    var artist: String?
    
    let comicTitleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    let stepper = UIStepper()
    let finishNumberTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let authorTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let artistTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    var pickerFieldName: String = ""
    var pickerData: [String] = []
    
    let typeData = ["Quadrinho", "Livro"]
    var typeIndex = 0
    let organizeByData = ["Página", "Capítulo", "Volume"]
    var organizeByIndex = 2
    let statusData = ["Lido", "Lendo", "Quero Ler"]
    var statusIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Criar Item"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        initNewitem()
        pickerFieldName = "OrganizeBy"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNewitem() {
        comicTitle = "-"
        progressNumber = 0
        organizeBy = "Volume"
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        comicTitleTextField.resignFirstResponder()
        finishNumberTextField.resignFirstResponder()
        authorTextField.resignFirstResponder()
        artistTextField.resignFirstResponder()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setInfo", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Nome "
            comicTitleTextField.textAlignment = .right
            comicTitleTextField.placeholder = "-"
            cell.accessoryView = comicTitleTextField
        case 1:
            if let organizeBy = organizeBy {
                if let progressNumber = progressNumber {
                    stepper.value = Double(progressNumber)
                    stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
                    if let finishNumber = finishNumber {
                        cell.textLabel?.text = "\(progressNumber)/\(finishNumber) (em \(organizeBy.lowercased())s)"
                    } else {
                        cell.textLabel?.text = "\(progressNumber)/- (em \(organizeBy.lowercased())s)"
                    }
                }
            }
            cell.accessoryView = stepper
        case 2:
            cell.textLabel?.text = "\(organizeBy ?? "-") final "
            finishNumberTextField.textAlignment = .right
            finishNumberTextField.placeholder = "-"
            cell.accessoryView = finishNumberTextField
        case 3:
            cell.textLabel?.text = "Tipo "
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            button.setTitle("\(typeData[typeIndex]) ", for: .normal)
            button.setTitleColor(.systemGray, for: .normal)
            button.addTarget(self, action: #selector(changeType), for: .touchUpInside)
            button.tag = indexPath.row
            button.semanticContentAttribute = .forceRightToLeft
            button.sizeToFit()
            cell.accessoryView = button
        case 4:
            cell.textLabel?.text = "Organizar por "
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            button.setTitle("\(organizeByData[organizeByIndex]) ", for: .normal)
            button.setTitleColor(.systemGray, for: .normal)
            button.addTarget(self, action: #selector(changeOrganizeBy), for: .touchUpInside)
            button.tag = indexPath.row
            button.semanticContentAttribute = .forceRightToLeft
            button.sizeToFit()
            cell.accessoryView = button
        case 5:
            cell.textLabel?.text = "Status "
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            button.setTitle("\(statusData[statusIndex]) ", for: .normal)
            button.setTitleColor(.systemGray, for: .normal)
            button.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
            button.tag = indexPath.row
            button.semanticContentAttribute = .forceRightToLeft
            button.sizeToFit()
            cell.accessoryView = button
        case 6:
            cell.textLabel?.text = "Autor/Roteiro "
            authorTextField.textAlignment = .right
            authorTextField.placeholder = "-"
            cell.accessoryView = authorTextField
        case 7:
            cell.textLabel?.text = "Ilustração "
            artistTextField.textAlignment = .right
            artistTextField.placeholder = "-"
            cell.accessoryView = artistTextField
        default:
            break
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    @objc func stepperValueChanged() {
        progressNumber = Int(stepper.value)
        tableView.reloadData()
    }
    
    @objc func changeType() {
        pickerFieldName = "Type"
        pickerData = typeData
        checkmark = typeIndex
        performSegue(withIdentifier: "PickerItemViewSegue", sender: self)
    }
    
    @objc func changeOrganizeBy() {
        pickerFieldName = "OrganizeBy"
        pickerData = organizeByData
        checkmark = organizeByIndex
        performSegue(withIdentifier: "PickerItemViewSegue", sender: self)
    }
    
    @objc func changeStatus() {
        pickerFieldName = "Status"
        pickerData = statusData
        checkmark = statusIndex
        performSegue(withIdentifier: "PickerItemViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
            let tableVC = navVC.topViewController as? PickerItemViewController
            tableVC?.delegate = self
            tableVC?.checkmark = checkmark
            tableVC?.pickerFieldName = pickerFieldName
            tableVC?.pickerData = pickerData
        }
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddToShelfViewController: ModalDelegate {
    func changeValue(value: Int) {
        checkmark = value
        switch pickerFieldName {
        case "Type":
            typeIndex = checkmark
        case "OrganizeBy":
            organizeByIndex = checkmark
        case "Status":
            statusIndex = checkmark
        default:
            break
        }
        tableView.reloadData()
    }
}
