//
//  FullNewsFeedVC.swift
//  NewsFeedRSS
//
//  Created by Борис Павлов on 01/02/2019.
//  Copyright © 2019 Boris. All rights reserved.
//

import UIKit
import Kingfisher

class FullNewsFeedVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var fullPubDateLabel: UILabel!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var fullTitleLabel: UILabel!
    @IBOutlet weak var fullTextViewState: UITextView!
    
    var imageURL = ""{
        didSet{
            let url = URL(string: imageURL)
            self.fullImageView.kf.setImage(with: url)
        }
    }
    
    var elementName: String = String()
    var choiseNewsFeed: NewsFeedData?
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        editingViews()
    }
    
    //MARK: - Methods
    func editingViews() {
        //font
        self.fullPubDateLabel.font = UIFont(name: "Times New Roman", size: 15)
        self.fullTitleLabel.font = UIFont(name: "Times New Roman", size: 22)
        self.fullTextViewState.font = UIFont(name: "Times New Roman", size: 16)
//        self.fullImageView.image = UIImage(named: "news")
        
        
        self.fullTitleLabel.text = self.choiseNewsFeed!.newsTitle
        self.fullPubDateLabel.text = self.choiseNewsFeed!.newsPubDate
        self.imageURL = self.choiseNewsFeed!.newsImage ?? "nil"
        self.fullTextViewState.text = self.choiseNewsFeed!.newsFullText
    }
}
