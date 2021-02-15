//
//  DataModel.swift
//  DZ12-TableView
//
//  Created by shizo on 18.01.2021.
//

import Foundation


enum DataType: Int {
    case folder = 0
    case image
}

struct CellData {
    var name: String?
    var imageNamed: String
    var type: DataType
}
