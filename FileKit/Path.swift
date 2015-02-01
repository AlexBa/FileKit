//
//  Path.swift
//  FileKit
//
//  Created by Alexander Barton on 01.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public protocol PathType {
    
    ///The path to the root directory
    class var root: Path { get }
    
    ///Check if the given path lays in the allowed scope of the filesystem
    class func isInAllowedScope(path: PathType) -> Bool
    
    ///Initializer with raw path
    init(_ raw: String)
    
    ///Initializer with path components
    init(components: [String])
    
    ///Raw path to the item
    var raw: String { get }
    
    ///The path's components
    var components: [String] { get }
    
     ///The path's item name
    var itemName: String { get }
    
    ///The item name's extension
    var itemNameExtension: String { get }
    
    ///The path to the within the scope accessible parent folder
    func parent() -> Path?
    
    ///Create a new path out of the current path and the given child path
    func child(path:String) -> Path
}

public class Path : PathType {
    
    ///Raw path to the item
    public var raw: String
    
    ///The path to the root directory
    public class var root: Path {
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true)[0] as String
            
        return Path(documentsPath)
    }
    
    ///The path's components
    public var components: [String] {
        return raw.pathComponents
    }
    
    ///The path's item name
    public var itemName: String {
        // Split the parts of the path
        let components = split(raw) {$0 == "/"}
            
        // Return the filename
        if components.last != "" {
            return components.last!
        } else {
            return components[components.count - 2]
        }
    }
    
    ///The item name's extension
    public var itemNameExtension: String {
        return raw.pathExtension
    }
    
    ///Initializer with raw path
    public required init(_ raw: String){
        self.raw = raw
    }
    
    ///Initializer with path components
    public required init(components: [String]) {
        raw = "/".join(components)
    }
   
    ///Check if the given path lays in the allowed scope of the filesystem
    public class func isInAllowedScope(path: PathType) -> Bool {
        if Path.root.raw.rangeOfString(path.raw) != nil {
            return true
        }
        
        return false;
    }
    
    ///The path to the within the scope accessible parent folder
    public func parent() -> Path? {
        // Move only to the parent if we are not at the root directory
        if Path.isInAllowedScope(self) {
            // Remove the last path component
            var components = raw.pathComponents
            components.removeLast()
            
            // Combine the components to a new path
            let path:String = "/".join(components);
            
            return Path(path);
        } else {
            return nil
        }
    }
    
    ///Create a new path out of the current path and the given child path
    public func child(path: String) -> Path {
        return Path("\(raw)/\(path)")
    }
}

///Make the path printable
extension Path : Printable {
    
    public var description: String {
        return raw
    }
}

///Check if both paths are equal
public func ==(lhs: PathType, rhs: PathType) -> Bool {
    return lhs.raw == rhs.raw
}

///Check if both paths are different
public func !=(lhs: PathType, rhs: PathType) -> Bool {
    return lhs.raw != rhs.raw
}
