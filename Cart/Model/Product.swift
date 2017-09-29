//
//  Product.swift
//  Cart
//
//  Created by Pavlo Muratov on 28.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import Foundation
import UIKit

class Product: Decodable {
    
    // MARK: - Types
    
    typealias ThumbnailCallback = (UIImage, Product, Bool) -> ()
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case currentPrice = "price"
        case oldPrice = "old_price"
        case thumbanilURL = "image"
    }
    
    // MARK: - Properties
    
    var id: Int
    var title: String
    var currentPrice: String
    var oldPrice: String?
    
    private let thumbanilURL: URL
    private let thumbnailCache = NSCache<NSString, UIImage>()
    private let downloadQueue = OperationQueue()
    
    // MARK: - Lifecycle
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        currentPrice = try container.decode(String.self, forKey: .currentPrice)
        oldPrice = try container.decode(String?.self, forKey: .oldPrice)
        thumbanilURL = try container.decode(URL.self, forKey: .thumbanilURL)
    }
    
    // MARK: - Private
    
    private func loadThumbnail(_ completionHandler: @escaping ThumbnailCallback) {
        guard downloadQueue.operationCount == 0 else { return }
        downloadQueue.addOperation { [weak self] in
            guard let strongSelf = self,
                let thumbnailData = try? Data(contentsOf: strongSelf.thumbanilURL),
                let thumbnail = UIImage(data: thumbnailData) else { return }
            
            strongSelf.thumbnailCache.setObject(thumbnail, forKey: strongSelf.thumbanilURL.absoluteString as NSString)
            completionHandler(thumbnail, strongSelf, false)
        }
    }
    
    // MARK: - Public
    
    func obtainThumbnail(_ completionHandler: @escaping ThumbnailCallback) {
        guard let cachedThumbnail = thumbnailCache.object(forKey: thumbanilURL.absoluteString as NSString) else {
            loadThumbnail(completionHandler)
            return
        }
        completionHandler(cachedThumbnail, self, true)
    }
}

// MARK: - Equatable
extension Product: Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
