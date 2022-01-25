//
//  FeedModel.swift
//  Feed
//
//  Created by Shad Mazumder on 24/1/22.
//

import Foundation

public struct FeedModel: Decodable{
    public let title: String
    public let description: String
    public let source: String
    
    public init(title: String, description: String, source: String){
        self.title = title
        self.description = description
        self.source = source
    }
}
