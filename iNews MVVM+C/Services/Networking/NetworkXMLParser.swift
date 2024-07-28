//
//  NetworkXMLParser.swift
//  iNews MVVM+C
//
//  Created by Слава on 21.07.2024.
//

import Foundation
import UIKit

//MARK: - Create var for XML Parse

final class NetworkXMLParser: NSObject, XMLParseProtocol {
    
    
    var newsItems: [New] = []
    var currentElement: String = ""
    var parserCompletionHandler: (([New]?, NetworkError?) -> Void)?
    
    
    var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.deleteHtmlSymbol()
        }
    }
    
    var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.deleteHtmlSymbol()
        }
    }
    
    var currentpubDate: String = "" {
        didSet {
            currentpubDate = currentpubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var currentImageLink: String = "" {
        didSet {
            currentImageLink = currentImageLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var currentLink: String = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    var currentResource: String = "" {
        didSet {
            currentResource = currentResource.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
}


//MARK: - Parse XML

extension NetworkXMLParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentpubDate = ""
            currentLink = ""
            currentImageLink = ""
        }
        
        if currentElement == "enclosure" {
            let attrsUrl = attributeDict as [String: NSString]
            let urlPic = attrsUrl["url"]
            currentImageLink = urlPic as? String ?? ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "rbc_news:full-text": currentDescription += string
        case "link": currentLink += string
        case "pubDate": currentpubDate += string
        case "rbc_news:url": currentImageLink = string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //
        if elementName == "item" {
            
            let newsItem = New(title: currentTitle, description: currentDescription, pubData: currentpubDate.getDate() ?? Date() , image: currentImageLink, source: currentResource, link: currentLink)
            self.newsItems.append(newsItem)
//            self.newsItems.sort(by: { $0.pubData > $1.pubData  })
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
 
        parserCompletionHandler?(newsItems, .none)
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
        print(parseError.localizedDescription)
    }
    
}

