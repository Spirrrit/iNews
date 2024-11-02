//
//  ImageOperation.swift
//  iNews MVVM+C
//
//  Created by Слава Васильев on 04.10.2024.
//

import Foundation

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum ImageRecordState {
    case New, Downloaded, Failed
}

class ImageRecord {
    
    let url: URL
    var state = ImageRecordState.New
    var image = UIImage(named: "emptyPhoto")
    
    init(str: String) {
        if let url = URL(string: str) {
            self.url = url
        } else {
            url = URL(string: "error")!
        }
        
        
    }
}

class PendingOperations {
    
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloader: Operation {
    
    let photoRecord: ImageRecord
    
    init(photoRecord: ImageRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        let imageData = NSData(contentsOf:self.photoRecord.url)
        
        if self.isCancelled {
            return
        }
        
        if imageData?.length ?? 0 > 0 {
            self.photoRecord.image = UIImage(data:imageData! as Data)
            self.photoRecord.state = .Downloaded
        }
        else {
            self.photoRecord.state = .Failed
            self.photoRecord.image = UIImage(named: "emptyPhoto")
        }
    }
}
