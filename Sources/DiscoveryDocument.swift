//
//  DiscoveryDocument.swift
//  Discovery
//
//  Created by Matthew Wyskiel on 4/24/17.
//
//

import Foundation
import GoogleyEyesCore
import SwiftyJSON

public struct DiscoveryDocument: ModelObject {
    
    public let kind = "discovery#restDescription"
    public var discoveryVersion: String
    public var id: String
    public var name: String
    public var version: String
    public var revision: String
    public var title: String
    public var description: String
    
    public struct Icons: ObjectType {
        public var x16: String
        public var x32: String
        
        public init(json: JSON) {
            x16 = json["x16"].stringValue
            x32 = json["x32"].stringValue
        }
        
        public func toJSON() -> JSON {
            return [
                "x16": x16,
                "x32": x32
            ]
        }
    }
    
    public var icons: Icons
    public var documentationLink: String
    public var labels: [String]
    public var `protocol`: String
    public var rootURL: String
    public var parameters: [String: Schema]
    
    public struct Auth: ObjectType {
        public var scopes: [String: String] //  { Key: Description }
        public init(json: JSON) {
            let oauthJSON = json["oauth2"]["scopes"]
            var scopesDict: [String: String] = [:]
            for (key, value) in oauthJSON {
                let description = value["description"].stringValue
                scopesDict[key] = description
            }
            scopes = scopesDict
        }
        public func toJSON() -> JSON {
            var dict: [String: Any] = [:]
            var scopesDict: [String: Any] = [:]
            for (key, value) in scopes {
                scopesDict[key] = [
                    "description": value
                ]
            }
            dict["oauth"] = ["scopes": scopesDict]
            return JSON(dict)
        }
    }
    
    public var auth: Auth
    public var features: [String]
    public var schemas: [String: Schema]
    public var methods: [String: Method]
    public var baseUrl: String // Deprecated
    public var basePath: String // Deprecated
    public var servicePath: String
    public var batchPath: String
    public var resources: [String: Resource]
    
    public init(json: JSON) {
        discoveryVersion = json["discoveryVersion"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        version = json["version"].stringValue
        revision = json["revision"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        icons = Icons(json: json["icons"])
        documentationLink = json["documentationLink"].stringValue
        labels = json["labels"].toJSONSubtypeArrayValue()
        self.protocol = json["protocol"].stringValue
        rootURL = json["rootUrl"].stringValue
        parameters = json["parameters"].toModelDictionaryValue()
        auth = Auth(json: json["auth"])
        features = json["features"].toJSONSubtypeArrayValue()
        schemas = json["schemas"].toModelDictionaryValue()
        methods = json["methods"].toModelDictionaryValue()
        baseUrl = json["baseUrl"].stringValue
        basePath = json["basePath"].stringValue
        servicePath = json["servicePath"].stringValue
        batchPath = json["batchPath"].stringValue
        resources = json["resources"].toModelDictionaryValue()
    }
    
    public func toJSON() -> JSON {
        return [
            "kind": kind,
            "discoveryVersion": discoveryVersion,
            "id": id,
            "name": name,
            "version": version,
            "revision": revision,
            "title": title,
            "description": description,
            "icons": icons.toJSON(),
            "documentationLink": documentationLink,
            "labels": labels,
            "protocol": self.protocol,
            "rootUrl": rootURL,
            "parameters": JSON(modelDict: parameters),
            "auth": auth.toJSON(),
            "features": features,
            "schemas": JSON(modelDict: schemas),
            "methods": JSON(modelDict: methods),
            "baseUrl": baseUrl,
            "basePath": basePath,
            "servicePath": servicePath,
            "batchPath": batchPath,
            "resources": JSON(modelDict: resources)
        ]
    }
    
    
}
