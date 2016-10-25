//
//  CustomCell.swift
//  swift proteins
//
//  Created by Melvin MOUSTAID on 10/19/16.
//  Copyright © 2016 Melvin MOUSTAID. All rights reserved.
//

import UIKit

class CustomCell : UITableViewCell {
    
    @IBOutlet weak var ligandLabel: UILabel!
    
    var ligand : String? {
        didSet {
            if let l = ligand {
                ligandLabel.text = l
            }
        }
    }
    
    
    
}
