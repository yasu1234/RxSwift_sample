//
//  RepositoryCell.swift
//  rxswift_sample
//
//  Created by kuma on 2020/12/31.
//

import UIKit

class RepositortCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    func setName(name: String) {
        self.name.text = name
    }
    
}
