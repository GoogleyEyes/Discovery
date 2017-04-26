//
//  Schema.swift
//  Discovery
//
//  Created by Matthew Wyskiel on 4/24/17.
//
//

import Foundation
import SwiftyJSON
import GoogleyEyesCore

public class Schema: ObjectType {
    
    public var id: String?
    
    public enum `Type`: String {
        case string = "string"
        case number = "number"
        case integer = "integer"
        case boolean = "boolean"
        case object = "object"
        case array = "array"
        case null = "null"
        case any = "any"
    }
    
    public var type: Type?
    public var xRef: String? // $ref
    public var description: String?
    public var defaultValue: String? // default
    public var required: Bool = false
    public enum Format: String {
        // Integer
        case int32 = "int32"
        case uint32 = "uint32"
        // Number
        case double = "double"
        case float = "float"
        // String
        case byte = "byte"
        case date = "date"
        case dateTime = "date-time"
        case int64 = "int64"
        case uint64 = "uint64"
    }
    public var format: Format?
    public var pattern: String?
    public var minimum: String?
    public var maximum: String?
    public var enumValues: [String]?
    public var enumDescriptions: [String]?
    public var repeated: Bool = false
    public var properties: [String: Schema]?
    public var additionalProperties: Schema?
    public var items: Schema?
    
    public struct Annotations: ObjectType {
        public var required: [String]?
        public init(json: JSON) {
            required = json["required"].toJSONSubtypeArray()
        }
        public func toJSON() -> JSON {
            return [
                "required": required ?? []
            ]
        }
    }
    public var annotations: Annotations?
    
    
    public enum ParameterLocation: String {
        case query = "query"
        case path = "path"
    }
    public var location: ParameterLocation?
    
    public required init(json: JSON) {
        id = json["id"].stringValue
        type = Type(rawValue: json["type"].stringValue)
        xRef = json["$ref"].string
        description = json["description"].string
        defaultValue = json["default"].string
        required = json["required"].boolValue
        format = Format(rawValue: json["format"].stringValue)
        pattern = json["pattern"].string
        minimum = json["minimum"].string
        maximum = json["maximum"].string
        enumValues = json["enum"].toJSONSubtypeArray()
        enumDescriptions = json["enumDescriptions"].toJSONSubtypeArray()
        repeated = json["repeated"].boolValue
        location = ParameterLocation(rawValue: json["location"].stringValue)
        properties = json["properties"].toModelDictionary()
        if json["additionalProperties"] != .null {
            additionalProperties = Schema(json: json["additionalProperties"])
        }
        if json["items"] != .null {
            items = Schema(json: json["items"])
        }
        if json["annotations"] != .null {
            annotations = Annotations(json: json["annotations"])
        }
    }
    
    public func toJSON() -> JSON {
        var dict: [String: Any] = [:]
        if let id = id {
            dict["id"] = id
        }
        if let type = type?.rawValue {
            dict["type"] = type
        }
        if let xRef = xRef {
            dict["$ref"] = xRef
        }
        if let description = description {
            dict["description"] = description
        }
        if let defaultValue = defaultValue {
            dict["default"] = defaultValue
        }
        dict["required"] = required
        if let format = format?.rawValue {
            dict["format"] = format
        }
        if let pattern = pattern {
            dict["pattern"] = pattern
        }
        if let min = minimum {
            dict["minimum"] = min
        }
        if let max = maximum {
            dict["maximum"] = max
        }
        if let enumValues = enumValues {
            dict["enum"] = enumValues
        }
        if let enumDescriptions = enumDescriptions {
            dict["enumDescriptions"] = enumDescriptions
        }
        dict["repeated"] = repeated
        if let location = location?.rawValue {
            dict["location"] = location
        }
        if let properties = properties {
            dict["properties"] = JSON(modelDict: properties)
        }
        if let additionalProps = additionalProperties {
            dict["additionalPoperties"] = additionalProps.toJSON()
        }
        if let items = items {
            dict["items"] = items.toJSON()
        }
        if let annotations = annotations {
            dict["annotations"] = annotations.toJSON()
        }
        return JSON(dict)
    }
    
}
