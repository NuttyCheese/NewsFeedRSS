//
//  NewsFeedTVC.swift
//  NewsFeedRSS
//
//  Created by Борис Павлов on 01/02/2019.
//  Copyright © 2019 Boris. All rights reserved.
//

import UIKit

//https://www.vesti.ru/vesti.rss

class NewsFeedTVC: UITableViewController, XMLParserDelegate {

    //MARK: - Properties
    let identifire = "MyCell"
    var newsFeeds: [NewsFeedData] = []
    var elementName: String = String()
    var newsTitle = String()
    var newsPubDate = String()
    var newsImage: String?
    var newsFullText = String()
    
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
        return newsFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath) as! NewsFeedTVCell
        
        let news = newsFeeds[indexPath.row]
  
        cell.titleLabel.text = news.newsTitle
        cell.pudDateLabel.text = news.newsPubDate
        
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
        
        /*
        if elementName == "item" {
            newsTitle = String()
            newsFullText = String()
            newsPubDate = String()
            newsImage = String()
        } else if elementName == "enclosure" {
            if let urlString = attributeDict["url"] {
                print(urlString)
                print("enc details")
                newsImage? += urlString
            } else {
                print("malformed element: enclosure without url attribute")
            }
        }
        */
        
        if elementName == "item" {
            newsTitle = String()
            newsPubDate = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let news = NewsFeedData.init(newsTitle: newsTitle, newsPubDate: newsPubDate, newsImage: newsImage, newsFullText: newsFullText)
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
            default:
                break
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let fullNewsFeed = segue.destination as? FullNewsFeedVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            fullNewsFeed?.choiseNewsFeed = newsFeeds[indexPath.item]
        }
    }
}
