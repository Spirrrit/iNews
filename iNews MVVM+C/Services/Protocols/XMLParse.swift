//
//  XMLParse.swift
//  iNews MVVM+C
//
//  Created by Слава on 22.07.2024.
//

import Foundation
import UIKit

protocol XMLParseProtocol {
    
    var newsItems: [New] { get }
    var currentElement: String { get }
    var parserCompletionHandler: (([New]?, NetworkError?) -> Void)? { get }
    
    
    var currentTitle: String { get set}
    var currentDescription: String { get set}
    var currentpubDate: String { get set}
    var currentImageLink: String { get set}
    var currentLink: String { get set}
    var currentResource: String { get set}
}
