//
//  NewsFeedTVCell.swift
//  NewsFeedRSS
//
//  Created by Борис Павлов on 01/02/2019.
//  Copyright © 2019 Boris. All rights reserved.
//

import UIKit

class NewsFeedTVCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pudDateLabel: UILabel!
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editingLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: - Methods
    func editingLabel() {
        self.titleLabel.font = UIFont(name: "Times New Roman", size: 22)
        self.pudDateLabel.font = UIFont(name: "Times New Roman", size: 15)
    }
    
}
