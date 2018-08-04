//
//  TransactionCell.swift
//  AirTouch New Media
//
//  Created by Adrian Popovici on 03/08/2018.
//  Copyright © 2018 adrian. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    var transaction: ProductData? {
        didSet {
            currencyLabel.text = transaction?.currency
            if let amount = transaction?.amount {
                amountLabel.text = String(describing: amount)
            } else {
                amountLabel.text = "Err"
            }
        }
    }
    var index: Int? {
        didSet {
            indexLabel.text = String(describing: index ?? 0)
        }
    }

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!

    func configure(withTransaction transaction: ProductData,
                   andIndex index: Int) {
        self.index = index
        self.transaction = transaction
    }
}
