//
//  CustomView.swift
//  DZ12-TableView
//
//  Created by shizo on 08.02.2021.
//

import UIKit

class CustomView: UIView {

  
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var UIImageView: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .black
        scrollView.delegate = self
    }
    
 
}

extension CustomView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return UIImageView
    }
}
