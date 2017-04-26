//
//  Method.swift
//  Discovery
//
//  Created by Matthew Wyskiel on 4/24/17.
//
//

import Foundation
import SwiftyJSON
import GoogleyEyesCore

public struct Method: ObjectType {
    public var id: String
    public var description: String
    public var parameters: [String: Schema]
    public var parameterOrder: [String]
    public var scopes: [String]
    public var supportsMediaDownlaod: Bool = false
    public var supportsMediaUpload: Bool = false
    
    public struct MediaUpload: ObjectType {
        public var acceptedMimeTypes: [String] // accept
        public var maxSize: String
        
        public struct `Protocol` {
            public static func simple(json: JSON) -> Protocol {
                return Protocol(isSimple: true, isResumable: false, type: "simple", multipart: json["multipart"].boolValue, path: json["path"].stringValue)
            }
            
            public static func resumable(json: JSON) -> Protocol {
                return Protocol(isSimple: false, isResumable: true, type: "resumable", multipart: json["multipart"].boolValue, path: json["path"].stringValue)
            }
            
            public var isSimple = false
            public var isResumable = false
            
            public var type: String
            public var multipart: Bool
            public var path: String
            
            public func toJSON() -> JSON {
                return [
                    "multipart": multipart,
                    "path": path
                ]
            }
        }
        
        public var protocols: [Protocol]
        
        public init(json: JSON) {
            acceptedMimeTypes = json["accept"].toJSONSubtypeArrayValue()
            maxSize = json["maxSize"].stringValue
            
            var protocols = [Protocol]()
            var protocolJSON = json["protocol"]
            if protocolJSON["simple"] != .null {
                protocols.append(Protocol.simple(json: protocolJSON["simple"]))
            }
            if protocolJSON["resumable"] != .null {
                protocols.append(Protocol.resumable(json: protocolJSON["resumable"]))
            }
            self.protocols = protocols
        }
        public func toJSON() -> JSON {
            var dict: [String: Any] = [
                "accept": acceptedMimeTypes,
                "maxSize": maxSize
            ]
            for prot in protocols {
                if prot.isSimple {
                    dict["protocols"] = ["simple": prot.toJSON()]
                } else if prot.isResumable {
                    dict["protocols"] = ["resumable": prot.toJSON()]
                }
            }
            return JSON(dict)
        }
    }
    public var mediaUpload: MediaUpload?
    public var supportsSubscription: Bool = false
    public var path: String
    public var httpMethod: String
    public var requestSchemaName: String? // request.$ref
    public var responseSchemaName: String? // response.$ref
    
    public init(json: JSON) {
        id = json["id"].stringValue
        description = json["description"].stringValue
        parameters = json["parameters"].toModelDictionaryValue()
        parameterOrder = json["parameterOrder"].toJSONSubtypeArrayValue()
        scopes = json["scopes"].toJSONSubtypeArrayValue()
        supportsMediaUpload = json["supportsMediaUpload"].boolValue
        mediaUpload = MediaUpload(json: json["mediaUpload"])
        supportsMediaDownlaod = json["supportsMediaDownload"].boolValue
        supportsSubscription = json["supportsSubscription"].boolValue
        path = json["path"].stringValue
        httpMethod = json["httpMethod"].stringValue
        requestSchemaName = json["request"]["$ref"].string
        responseSchemaName = json["response"]["$ref"].string
    }
    public func toJSON() -> JSON {
        var dict: [String: Any] = [
            "id": id,
            "description": description,
            "parameters": JSON(modelDict: parameters),
            "parameterOrder": parameterOrder,
            "scopes": scopes,
            "supportsMediaUpload": supportsMediaUpload,
            "supportsMediaDownload": supportsMediaDownlaod,
            "supportsSubscription": supportsSubscription,
            "path": path,
            "httpMethod": httpMethod,
        ]
        if let reqSchema = requestSchemaName {
            dict["request"] = ["$ref": reqSchema]
        }
        if let resSchema = responseSchemaName {
            dict["response"] = ["$ref": resSchema]
        }
        if let uploadSupport = mediaUpload?.toJSON() {
            dict["mediaUpload"] = uploadSupport
        }
        
        return JSON(dict)
    }
}
