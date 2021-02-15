//
//  ViewController.swift
//  DZ12-TableView
//
//  Created by shizo on 18.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Properties -
    
    var folderData: [CellData] = []
    var folderNames: [String] = []
    let fileManager = FileManager.default
    var directoryURL: URL?
    var selectedObjects: [CellData] = []
    let notificationIdentifierArray = ["notification","notification1","notification2","notification3","notification4","notification5",]
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var addItemsButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var changeUiButtonOutlet: UIBarButtonItem!
    
    
    //MARK:- IBOutlets -
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.delegate = self
            mainTableView.dataSource = self
            let nib = UINib(nibName: TableViewRegister.nibNameMainTableView.rawValue, bundle: nil)
            let newNib = UINib(nibName: TableViewRegister.nibNameimageTableView.rawValue, bundle: nil)
            mainTableView.register(nib, forCellReuseIdentifier: TableViewRegister.mainTableViewIdentifier.rawValue)
            mainTableView.register(newNib, forCellReuseIdentifier: TableViewRegister.imageTableViewIdentifier.rawValue)
            mainTableView.rowHeight = 100
            mainTableView.tableFooterView = UIView()
        }
        
        
    }
    @IBOutlet weak var mainCollectionView: UICollectionView! {
        didSet {
            mainCollectionView.delegate = self
            mainCollectionView.dataSource = self
            let nib = UINib(nibName: "MainCollectionViewCell", bundle: nil)
            mainCollectionView.register(nib, forCellWithReuseIdentifier: "mainCollCell")
            //123
            
        }
    }
    //123
    //MARK:- LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.allowsMultipleSelection = true
        editButtonOutlet.title = "Edit"
        checkURL()
        getDocuments(nameOfFolder: nil, folderUrls: directoryURL!)
        changeUiButtonOutlet.image = UIImage(systemName: "table")
        createNotifictaion()
    }
    //MARK:- Functions -
    
    func checkURL() {
        if directoryURL == nil {
            directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }

    }
    
    func addAlert() {
        let alert = UIAlertController(title: "Add new folder", message: "", preferredStyle: .alert)
        alert.addTextField { (userNameField) in
            userNameField.font = .systemFont(ofSize: 17)
            userNameField.placeholder = "Name of folder"
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                guard let textField = userNameField.text else { return }
                if (userNameField.text!.isEmpty)  {
                    self.showNotCorrectAlert()
                    return
                } else {
                    self.createDirectory(nameOfFolder: textField, FoldersUrl: self.directoryURL!)
                    self.getDocuments(nameOfFolder: textField, folderUrls: self.directoryURL!)
                }
            }
            alert.addAction(okAction)
        }
        let cancelACtion = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelACtion)
        present(alert, animated: true, completion: nil)
    }
    
    func showNotCorrectAlert() {
        showAlert(title: "Error", message: "Name of folder empty", actionTitles: ["Try again"], actions: [{action1 in
            self.addAlert()
        }])
    }
    
    func createDirectory(nameOfFolder : String, FoldersUrl: URL) {
        
        let directoryURL = FoldersUrl
        
        do {
            let contentOfDirectory = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            let newFolderUrl = directoryURL.appendingPathComponent(nameOfFolder)
            try fileManager.createDirectory(at: newFolderUrl, withIntermediateDirectories: false, attributes: nil)
            
        } catch {
            print("something went wrong")
        }
    }
    
    func getDocuments(nameOfFolder: String?, folderUrls: URL) {
        let directoryURL = folderUrls
        do {
            folderData = []
            folderNames = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil).map {$0.lastPathComponent}
            for i in 0..<folderNames.count {
                if folderNames[i].contains(".jpeg") {
                    self.folderData.append(CellData(name: folderNames[i], imageNamed: "Image", type: .image))
                } else {
                    self.folderData.append(CellData(name: folderNames[i], imageNamed: "Folder", type: .folder))
                }
                folderData.sort(by: {$0.name! < $1.name!})
                
            }
            mainTableView.reloadData()
            mainCollectionView.reloadData()
        } catch  {
            print("Something went wrong")
        }
    }
    
    func deleteDocuments(nameOfFolder: String , folderUrl: URL) {
        
        let directoryURL = folderUrl
        
        do {
            let contentOfDirectory = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
            let newFolderUrl = directoryURL.appendingPathComponent(nameOfFolder)
            try fileManager.removeItem(at: newFolderUrl)
            
        } catch  {
            print("something wrong")
        }
    }
    
    func createImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func newAlert() {
        showAlert(title: "Select an option", message: nil, actionTitles: ["Создать папку","Добавить Фото"], actions:[{action1 in
            self.addAlert()
        },{action2 in
            self.createImagePicker()
        }])
    }
    
    //MARK:- IBActions-
    @IBAction func buttonPress(_ sender: UIBarButtonItem) {
        newAlert()
    }
    
    
    @IBAction func changeViewButtonPress(_ sender: UIBarButtonItem) {
        if mainTableView.alpha == 0 {
            changeUiButtonOutlet.image = UIImage(systemName: "list.dash")
            mainTableView.alpha = 1
            mainCollectionView.alpha = 0
            mainTableView.reloadData()
            mainCollectionView.reloadData()
        } else {
            changeUiButtonOutlet.image = UIImage(systemName: "table")
            mainTableView.alpha = 0
            mainCollectionView.alpha = 1
            mainTableView.reloadData()
            mainCollectionView.reloadData()
        }
    }
    
    @objc func addFolders() {
        newAlert()
    }
    
    @objc func deleteSelectedItems() {
        for objects in selectedObjects {
            if let directoryURL = directoryURL,
               let objectName = objects.name {
                do {
                    try fileManager.removeItem(at: directoryURL.appendingPathComponent(objectName))
                    folderData.removeAll(where: {$0.name == objects.name})
                    selectedObjects.removeAll(where: {$0.name == objects.name})
                } catch {
                    print("something went wrong")
                }
            }
        }
        mainCollectionView.reloadData()
        mainTableView.reloadData()
        editButtonOutlet.title = "Edit"
        changeUiButtonOutlet.isEnabled = true
        addButton()
    }
    
    func addButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolders))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func deleteButton() {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedItems))
        navigationItem.rightBarButtonItem = deleteButton
    }
    
    func changeButton() {
        let changeButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        navigationItem.rightBarButtonItem = changeButton
    }
    
    @IBAction func editButtonPress(_ sender: UIBarButtonItem) {
        
        if editButtonOutlet.title == "Edit" {
            sender.title = "Cancel"
            deleteButton()
            changeUiButtonOutlet.isEnabled = false
        } else {
            sender.title = "Edit"
            addButton()
            changeUiButtonOutlet.isEnabled = true
            mainTableView.reloadData()
            mainCollectionView.reloadData()
        }
    }
    
    
    func createNotifictaion() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { (isAutorized, error) in
            if isAutorized {
                let content = UNMutableNotificationContent()
                content.body = "Добавь фото в защищенную папку"
                
                for identifier in 0..<self.notificationIdentifierArray.count {
                    let identifier = self.notificationIdentifierArray[identifier]
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60 * 60, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    notificationCenter.add(request) { (error) in
                        if let error = error {
                            print(error)
                        }
                    }
                }
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
}




//MARK:- ImagePickerDelegateExtension -
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage,
           let url = info[.imageURL] as? URL {
            if let newUrl = directoryURL {
                let directoryUrl = newUrl
                
                
                do {
                    let newImageUrl = (directoryUrl.appendingPathComponent(url.lastPathComponent))
                    
                    let pngImageData = originalImage.pngData()
                    
                    try pngImageData?.write(to: newImageUrl)
                } catch {
                    print("Something went wrong")
                }
            }
        }
        getDocuments(nameOfFolder: nil, folderUrls: directoryURL!)
        picker.dismiss(animated: true, completion: nil)
    }
}



//MARK:- TableViewExtension -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentData = folderData[indexPath.row]
        switch currentData.type {
        case .image:
            if let imageCell = tableView.dequeueReusableCell(withIdentifier: TableViewRegister.imageTableViewIdentifier.rawValue, for: indexPath) as? ImageTableViewCell,
               let imageName = currentData.name {
                imageCell.nameOfImageLabel.text = currentData.name
                
                
                if let newUrl = directoryURL {
                    
                    
                    do {
                        let imageUrl = newUrl.appendingPathComponent(imageName)
                        imageCell.cellImageView.image = UIImage(contentsOfFile: imageUrl.path)
                    }
                    return imageCell
                }
            }
        case .folder:
            if let folderCell = tableView.dequeueReusableCell(withIdentifier: TableViewRegister.mainTableViewIdentifier.rawValue, for: indexPath) as? MainTableViewCell {
                folderCell.configure(result: folderData[indexPath.row])
                return folderCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentData = folderData[indexPath.row]
        
        if editButtonOutlet.title == "Edit" {
            switch currentData.type {
            case .image:
                if let imageName = currentData.name {
                    let imageController = ImageViewController(nibName: ImageViewController.identifier, bundle: nil)
                    
                    if let newUrl = directoryURL {
                        
                        do {
                            //let imageUrl = newUrl.appendingPathComponent(imageName)
                            //imageController.fullImage = UIImage(contentsOfFile: imageUrl.path)
                            imageController.folderDirectoryURL = directoryURL
                            self.navigationController?.pushViewController(imageController, animated: true)
                        }
                    }
                }
            case .folder:
                
                let vc = storyboard?.instantiateViewController(identifier: "mainVC") as! ViewController
                let currentData = folderData[indexPath.row]
                if let folderName = currentData.name, let newDirectoryUrl = directoryURL {
                    do {
                        let folderUrl = newDirectoryUrl.appendingPathComponent(folderName)
                        vc.directoryURL = folderUrl
                    }
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }
            tableView.cellForRow(at: indexPath)?.isSelected = false
        } else {
            selectedObjects.append(currentData)
            mainCollectionView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let currentData = folderData[indexPath.row]
        
        if editButtonOutlet.title == "Cancel" {
            selectedObjects.removeAll(where: {$0.name == currentData.name})
            mainCollectionView.reloadData()
        }
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            deleteDocuments(nameOfFolder: folderData[indexPath.row].name ?? " ", folderUrl: directoryURL!)
    //            folderData.remove(at: indexPath.row)
    //
    //            tableView.reloadData()
    //        }
    //    }
    
}


//MARK:- CollectionView extension
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentData = folderData[indexPath.row]
        switch currentData.type {
        case .image:
            if let imageCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCollCell", for: indexPath) as? MainCollectionViewCell,
               let imageName = currentData.name {
                imageCell.nameOfImageLabel.text = currentData.name
                
                imageCell.setSelectedAppearence(isSelected: selectedObjects.contains(where: { $0.name == currentData.name}))
                if let newUrl = directoryURL {
                    
                    
                    do {
                        let imageUrl = newUrl.appendingPathComponent(imageName)
                        
                        imageCell.cellImageView.image = UIImage(contentsOfFile: imageUrl.path)
                    }
                    return imageCell
                }
            }
        case .folder:
            if let folderCell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCollCell", for: indexPath) as? MainCollectionViewCell {
                folderCell.configure(result: folderData[indexPath.row])
                folderCell.setSelectedAppearence(isSelected: selectedObjects.contains(where: { $0.name == currentData.name}))
                return folderCell
            }
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentData = folderData[indexPath.row]
        
        
        if editButtonOutlet.title == "Edit" {
            switch currentData.type {
            case .image:
                if let imageName = currentData.name {
                    let imageController = ImageViewController(nibName: ImageViewController.identifier, bundle: nil)
                    
                    if let newUrl = directoryURL {
                        
                        
                        
                        do {
                            //let imageUrl = newUrl.appendingPathComponent(imageName)
                            //imageController.fullImage = UIImage(contentsOfFile: imageUrl.path)
                            imageController.folderDirectoryURL = directoryURL
                            self.navigationController?.pushViewController(imageController, animated: true)
                        }
                    }
                }
            case .folder:
                
                let vc = storyboard?.instantiateViewController(identifier: "mainVC") as! ViewController
                let currentData = folderData[indexPath.row]
                if let folderName = currentData.name, let newDirectoryUrl = directoryURL {
                    do {
                        let folderUrl = newDirectoryUrl.appendingPathComponent(folderName)
                        vc.directoryURL = folderUrl
                    }
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if selectedObjects.contains(where: {$0.name == currentData.name}) {
                selectedObjects.removeAll(where: {$0.name == currentData.name})
            } else {
                selectedObjects.append(currentData)
            }
            mainCollectionView.reloadData()
        }
        
        mainCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    
}

