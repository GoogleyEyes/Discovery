//
//  DirectoryList.swift
//  Discovery
//
//  Created by Matthew Wyskiel on 4/26/17.
//
//

import Foundation
import GoogleyEyesCore
import SwiftyJSON

public struct DirectoryList: ModelObjectList {
    public let kind = "discovery#directoryList"
    public var discoveryVersion: String
    public var items: [DirectoryItem]
    public init(json: JSON) {
        discoveryVersion = json["discoveryVersion"].stringValue
        items = json["items"].toModelArrayValue()
    }
    public func toJSON() -> JSON {
        return [
            "kind": kind,
            "discoveryVersion": discoveryVersion,
            "items": items.map { $0.toJSON() }
        ]
    }
    
}

public struct DirectoryItem: ModelObject {
    public let kind = "discovery#directoryItem"
    public var id: String
    public var name: String
    public var version: String
    public var title: String
    public var description: String
    public var discoveryRestUrl: String
    public var discoveryLink: String
    public var icons: DiscoveryDocument.Icons
    public var documentationLink: String
    public var labels: [String]
    public var preferred: Bool
    
    public init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        version = json["version"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        discoveryRestUrl = json["discoveryRestUrl"].stringValue
        discoveryLink = json["discoveryLink"].stringValue
        icons = DiscoveryDocument.Icons(json: json["icons"])
        documentationLink = json["documentationLink"].stringValue
        labels = json["labels"].toJSONSubtypeArrayValue()
        preferred = json["preferred"].boolValue
    }
    public func toJSON() -> JSON {
        return [
            "kind": kind,
            "id": id,
            "name": name,
            "version": version,
            "title": title,
            "description": description,
            "discoveryRestUrl": discoveryRestUrl,
            "discoveryLink": discoveryLink,
            "icons": icons.toJSON(),
            "documentationLink": documentationLink,
            "labels": labels,
            "preferred": preferred
        ]
    }
}
