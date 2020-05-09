//
//  ShoppingItemViewCell.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 07/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit


class ShoppingItemViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setData(itemLabel:String, amountLabel:String){
        self.itemLabel.text = itemLabel
        self.amountLabel.text = amountLabel
    }
    
    func setData(item: ShoppingItem){
        self.itemLabel.text = item.name! as String
        self.amountLabel.text = item.quantity! as String
    }
}
