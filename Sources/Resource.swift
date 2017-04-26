//
//  Resource.swift
//  Discovery
//
//  Created by Matthew Wyskiel on 4/25/17.
//
//

import Foundation
import SwiftyJSON
import GoogleyEyesCore

public class Resource: ObjectType {
    public var methods: [String: Method]
    public var resources: [String: Resource]
    
    public required init(json: JSON) {
        methods = json["methods"].toModelDictionaryValue()
        resources = json["resources"].toModelDictionaryValue()
    }
    
    public func toJSON() -> JSON {
        return [
            "methods": JSON(modelDict: methods),
            "resources": JSON(modelDict: resources)
        ]
    }
}
