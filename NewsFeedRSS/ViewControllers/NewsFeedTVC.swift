//
//  NewsFeedTVC.swift
//  NewsFeedRSS
//
//  Created by Борис Павлов on 01/02/2019.
//  Copyright © 2019 Boris. All rights reserved.
//

import UIKit

class NewsFeedTVC: UITableViewController, XMLParserDelegate {

    //MARK: - Properties
    let identifire = "MyCell"
    var newsFeeds: [NewsFeedData] = []
    var filteredNewsFeed: [NewsFeedData] = []
    var newCategories: [String] = []
    var elementName: String = String()
    var newsTitle = String()
    var newsPubDate = String()
    var newsImage: String?
    var newsFullText = String()
    var newsCategory = String()
    var currentCategory = "Все категории"
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        parsingNewsFeedXML()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    //MARK: - Methods
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentCategory == "Все категории" {
            return newsFeeds.count
        }else {
            self.filteredNewsFeed = newsFeeds.filter{ $0.newsCategory == self.currentCategory }
            return filteredNewsFeed.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as! NewsFeedTVCell
        
        var news: NewsFeedData? = nil
        
        if currentCategory == "Все категории" {
            news = newsFeeds[indexPath.row]
        }else {
            news = filteredNewsFeed[indexPath.row]
        }
        cell.titleLabel.text = news?.newsTitle
        cell.pudDateLabel.text = news?.newsPubDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //MARK: - XML Parsing
    func parsingNewsFeedXML() {
        if let path = Bundle.main.url(forResource: "News", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
 
        if elementName == "item" {
            newsTitle = String()
            newsFullText = String()
            newsPubDate = String()
            newsImage = String()
            newsCategory = String()
        } else if elementName == "enclosure" {
            if let urlString = attributeDict["url"] {
                newsImage? += urlString
            }
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news = NewsFeedData.init(newsTitle: newsTitle, newsPubDate: newsPubDate, newsImage: newsImage, newsFullText: newsFullText, newsCategory: newsCategory)
            newsFeeds.append(news)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            switch self.elementName {
            case "title":
                newsTitle += data
            case "pubDate":
                newsPubDate += data
            case "enclosure":
                newsImage? += data
            case "yandex:full-text":
                newsFullText += data
            case "category":
                newsCategory += data
                newCategories.append(newsCategory)
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let nextVC = segue.destination as? FullNewsFeedVC {
            var news: [NewsFeedData] = []
            
            if currentCategory == "Все категории" {
                news = newsFeeds
            }else {
                news = filteredNewsFeed
            }
            
            if let indexPath = tableView.indexPathForSelectedRow {
                nextVC.choiseNewsFeed = news[indexPath.item]
            }
        }else if let nextVC = segue.destination as? FiltersTVC {
            var unicCategories = Array(Set(self.newCategories)).sorted{ $0 < $1 }
            unicCategories.insert("Все категории", at: 0)
            nextVC.categories = unicCategories
        }
        
    }
    
    @IBAction func newsFeedFiltersSegue(with segue: UIStoryboardSegue) {
        guard let sourceVC = segue.source as? FiltersTVC else { return }
        self.currentCategory = sourceVC.category
        self.tableView.reloadData()
    }
    
}
