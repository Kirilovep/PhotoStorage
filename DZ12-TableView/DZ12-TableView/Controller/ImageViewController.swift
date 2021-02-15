//
//  ImageViewController.swift
//  DZ12-TableView
//
//  Created by shizo on 25.01.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    static let identifier = "ImageViewController"
    
    let fileManager = FileManager.default
    var folderDirectoryURL: URL?
    var imageNames: [String] = []
    var imagesData: [UIImage] = []
    let customView = CustomView()
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newUrl = folderDirectoryURL {
            getDocuments(folderUrl: newUrl)
        }
        createNewViews()
        
        
    }
    
    
    
    func createNewViews() {
        
        for view in 0..<imagesData.count {
            let currentImage = imagesData[view]
            if let customView = Bundle.main.loadNibNamed("CustomView", owner: nil, options: nil)?.first as? CustomView {
                customView.UIImageView.image = currentImage
                stackView.addArrangedSubview(customView)
                NSLayoutConstraint.activate([
                    customView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                    customView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                ])
            }
            
        }
    }
    
    
    
    
    func getDocuments(folderUrl: URL) {
        let directoryURL = folderUrl
        
        do {
            imageNames = []
            imageNames = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil).map {$0.lastPathComponent}
            
            for i in 0..<imageNames.count {
                if imageNames[i].contains(".jpeg") {
                    if let newUrl = folderDirectoryURL {
                        let imageUrl = newUrl.appendingPathComponent(imageNames[i])
                        imagesData.append(UIImage(contentsOfFile: imageUrl.path)!)
                    }
                }
            }
        } catch  {
            print("Something went wrong")
        }
    }
    
}





