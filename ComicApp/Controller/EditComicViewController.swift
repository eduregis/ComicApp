//
//  EditComicViewController.swift
//  ComicApp
//
//  Created by Eduardo Oliveira on 21/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class EditComicViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var checkmark = 0
    
    var comic: Comic?
    
    var imagePickerButton = UIButton()
    
    var comicTitle: String?
    var pickedImage: Data?
    var progressNumber: Int?
    var finishNumber: Int?
    var type: String?
    var organizeBy: String?
    var status: String?
    var author: String?
    var artist: String?
    
    var imageView = UIImageView()
    
    let comicTitleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    let stepper = UIStepper()
    let progressNumberTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let finishNumberTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let authorTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let artistTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    let imagePicker = UIImagePickerController()
    
    var pickerFieldName: String = ""
    var pickerData: [String] = []
    
    let typeData = ["Quadrinho", "Livro"]
    var typeIndex = 0
    let organizeByData = ["Página", "Capítulo", "Volume"]
    var organizeByIndex = 2
    let statusData = ["Lendo", "Lido", "Quero Ler"]
    var statusIndex = 2
    
    let nameRequiredAlert = UIAlertController(title: "Atenção", message: "O campo de nome deve ser preenchido", preferredStyle: .alert)
    let deleteAlert = UIAlertController(title: "Atenção", message: "Esse item irá ser apagado, deseja continuar?", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Editar Item"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        loaditem()
        pickerFieldName = "OrganizeBy"
        progressNumberTextField.keyboardType = .numberPad
        finishNumberTextField.keyboardType = .numberPad
        self.imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow), name:
                                                UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
        addActions()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[
                                UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 80
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loaditem() {
        if let comic = comic {
            comicTitle = comic.title
            progressNumber = comic.progressNumber
            finishNumber = comic.finishNumber
            pickedImage = comic.image
            author = comic.author
            artist = comic.artist
            switch comic.type {
            case "Quadrinho":
                type = typeData[0]
                typeIndex = 0
            case "Livro":
                type = typeData[1]
                typeIndex = 1
            default:
                break
            }
            
            switch comic.organizeBy {
            case "Página":
                organizeBy = organizeByData[0]
                organizeByIndex = 0
            case "Capítulo":
                organizeBy = organizeByData[1]
                organizeByIndex = 1
            case "Volume":
                organizeBy = organizeByData[2]
                organizeByIndex = 2
            default:
                break
            }
            
            switch comic.status {
            case "Lendo":
                statusIndex = 0
            case "Lido":
                statusIndex = 1
            case "Quero Ler":
                statusIndex = 2
            default:
                break
            }
            //status = comic.status
            organizeBy = organizeByData[organizeByIndex]
        }
    }
    
    func addActions() {
        nameRequiredAlert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default))
        deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        deleteAlert.addAction(UIAlertAction(title: NSLocalizedString("Confirmar", comment: "Default action"), style: .destructive, handler: { _ in
            self.deleteData()
        }))
    }
    
    func deleteData() {
        switch comic?.status {
        case "Quero Ler":
            Database.shared.deleteData(from: .wantToRead, at: comic!.comicId)
        case "Lido":
            Database.shared.deleteData(from: .read, at: comic!.comicId)
        case "Lendo":
            Database.shared.deleteData(from: .reading, at: comic!.comicId)
        default:
            break
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        comicTitleTextField.resignFirstResponder()
        progressNumberTextField.resignFirstResponder()
        finishNumberTextField.resignFirstResponder()
        authorTextField.resignFirstResponder()
        artistTextField.resignFirstResponder()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        if let finishNumberValue = finishNumberTextField.text {
            if finishNumber != Int(finishNumberValue) {
                ajustStatus()
            }
        }
        
        if let progressNumberValue = progressNumberTextField.text {
            if progressNumber != Int(progressNumberValue) && progressNumberValue != "" {
                ajustStatus()
            }
        }
        
        comicTitle = comicTitleTextField.text
        if comicTitleTextField.text != "" {
            type = typeData[typeIndex]
            organizeBy = organizeByData[organizeByIndex]
            if finishNumberTextField.text == "" {
                finishNumber = nil
            } else {
                finishNumber = Int(finishNumberTextField.text ?? "0")
            }
            if progressNumberTextField.text != "" {
                progressNumber = Int(progressNumberTextField.text ?? "0")
            }
            author = authorTextField.text
            artist = artistTextField.text
        
            ajustStepper()
            
            var editComic = Comic(comicId: comic!.comicId, title: comicTitle!, image: pickedImage, progressNumber: progressNumber, finishNumber: finishNumber, type: type!, organizeBy: organizeBy!, status: "-", author: author, artist: artist)
            
            editComic.color = comic?.color
            
            var statusType: StatusType
            
            switch statusIndex {
            case 0:
                editComic.status = "Lendo"
                statusType = .reading
            case 1:
                editComic.status = "Lido"
                statusType = .read
            case 2:
                editComic.status = "Quero Ler"
                statusType = .wantToRead
            default:
                editComic.status = "Quero Ler"
                statusType = .wantToRead
            }
            
            if let oldStatus = comic?.status {
                if oldStatus != editComic.status {
                    deleteData()
                    Database.shared.addData(comic: editComic, statusType: statusType)
                }
            }
            Database.shared.editData(comic: editComic, statusType: statusType)
            
            
            navigationController?.popViewController(animated: true)
        } else {
            nameRequiredTrigger()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        imageView.backgroundColor = .systemGray2
        imageView.frame = CGRect(x: 0, y: 0, width: 2*tableView.center.x, height: tableView.center.x)
        if let image = pickedImage {
            imageView.image = UIImage(data: image)
        }
        imageView.contentMode = .scaleAspectFit
        headerView.addSubview(imageView)
        imagePickerButton.frame = CGRect(x: 2*tableView.center.x - 40, y: tableView.center.x - 40, width: 40, height: 20)
        imagePickerButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        imagePickerButton.setTitleColor(.systemBlue, for: .normal)
        imagePickerButton.addTarget(self, action: #selector(toggleImagePicker), for: .touchUpInside)
        headerView.addSubview(imagePickerButton)
        return headerView
    }
    
    @objc func toggleImagePicker() {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.center.x
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setInfo", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Nome "
            comicTitleTextField.textAlignment = .right
            comicTitleTextField.text = comicTitle
            cell.accessoryView = comicTitleTextField
        case 1:
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
        case 2:
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
        case 3:
            cell.textLabel?.text = "\(organizeBy ?? "-") final "
            finishNumberTextField.textAlignment = .right
            var finishNumberValue = "\(finishNumber ?? 0)"
            if finishNumberValue == "0" {
                finishNumberValue = ""
                finishNumberTextField.placeholder = "-"
            }
            finishNumberTextField.text = finishNumberValue
            
            finishNumberTextField.addTarget(self, action: #selector(finishNumberValueChanged), for: .editingDidEnd)
            cell.accessoryView = finishNumberTextField
        case 4:
            if let organizeBy = organizeBy {
                if let progressNumber = progressNumber {
                    if let finishNumber = finishNumber {
                        cell.textLabel?.text = "\(progressNumber)/\(finishNumber) (em \(organizeBy.lowercased())s)"
                    } else {
                        cell.textLabel?.text = "\(progressNumber)/- (em \(organizeBy.lowercased())s)"
                    }
                    if organizeBy != organizeByData[0] {
                        stepper.value = Double(progressNumber)
                        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
                        cell.accessoryView = stepper
                    } else {
                        progressNumberTextField.textAlignment = .right
                        progressNumberTextField.text = "\(String(describing: progressNumber))"
                        progressNumberTextField.addTarget(self, action: #selector(progressNumberValueChanged), for: .editingDidEnd)
                        cell.accessoryView = progressNumberTextField
                    }
                }
            }
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
            authorTextField.text = author
            cell.accessoryView = authorTextField
        case 7:
            cell.textLabel?.text = "Ilustração "
            artistTextField.textAlignment = .right
            artistTextField.text = artist
            cell.accessoryView = artistTextField
        case 8:
            let button = UIButton(type: .custom)
            button.setTitle("Excluir item ", for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(deleteTrigger), for: .touchUpInside)
            button.sizeToFit()
            button.center = CGPoint(x: tableView.center.x, y: 22)
            cell.addSubview(button)
        default:
            break
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.backgroundColor = .systemGray6
        return cell
    }
    
    @objc func deleteTrigger () {
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    func nameRequiredTrigger () {
        self.present(nameRequiredAlert, animated: true, completion: nil)
    }
    
    @objc func stepperValueChanged() {
        progressNumber = Int(stepper.value)
        ajustStepper()
        ajustStatus()
        tableView.reloadData()
    }
    
    @objc func progressNumberValueChanged() {
        progressNumber = Int(progressNumberTextField.text ?? "0")
        ajustStepper()
        ajustStatus()
        tableView.reloadData()
    }
    
    @objc func finishNumberValueChanged() {
        finishNumber = Int(finishNumberTextField.text ?? "0")
        ajustStepper()
        ajustStatus()
        tableView.reloadData()
    }
    
    func ajustStatus() {
        if finishNumber != nil {
            if progressNumber == 0 {
                statusIndex = 2
            } else {
                if progressNumber == finishNumber {
                    statusIndex = 1
                } else {
                    statusIndex = 0
                }
            }
        } else {
            if progressNumber == 0 {
                statusIndex = 2
            } else {
                statusIndex = 0
            }
        }
    }
    
    func ajustStepper () {
        if let max = finishNumber {
            if let min = progressNumber {
                if max < min {
                    progressNumber = max
                }
            }
            stepper.maximumValue = Double(max)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            if let data = image.pngData() {
                imageView.image = UIImage(data: data)
                pickedImage = data
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditComicViewController: ModalDelegate {
    func changeValue(value: Int) {
        checkmark = value
        switch pickerFieldName {
        case "Type":
            typeIndex = checkmark
        case "OrganizeBy":
            organizeByIndex = checkmark
        case "Status":
            statusIndex = checkmark
            status = statusData[statusIndex]
        default:
            break
        }
        organizeBy = organizeByData[organizeByIndex]
        tableView.reloadData()
    }
}
