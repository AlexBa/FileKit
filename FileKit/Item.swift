//
//  Item.swift
//  FileKit
//
//  Created by Alexander Barton on 01.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public protocol ItemType  {
    
    ///The name of the item
    var name: String { get }
    
    ///The path on the disk
    var path: PathType { get }
    
    ///The parent directory
    var parent: Directory? { get }
    
    ///The attributes of the item
    var attributes: NSDictionary? { get }
    
    ///The error of the last operation
    var lastError: NSError? { get }
    
    ///Initilizer with path
    init(path: PathType)
    
    ///Delete the item on the disk
    func delete() -> Bool
    
    ///Check if the item exists on the disk
    func exits() -> Bool
    
    ///Rename the item on the disk
    func rename(toName: String) -> Bool
    
    ///Move the item to the given path on the disk
    func move(toPath: PathType) -> Bool
    
    ///Copy the content to a file at the given path
    func copy(toPath: PathType) -> Bool
}

public class Item : ItemType {
    
    ///The filemanager of the item
    var fileManager = NSFileManager.defaultManager()

    ///The name of the item
    public var name: String {
        return path.components.last!
    }
    
    ///The path on the disk
    public var path: PathType 
    
    ///The parent directory
    public var parent: Directory? {
        if let parent = path.parent() {
            return Directory(path: parent)
        }
        
        return nil
    }
    
    ///The attributes of the item
    public var attributes: NSDictionary? {
        return fileManager.attributesOfItemAtPath(path.raw, error: &lastError)
    }
    
    ///The size of the item
    public var size: UInt64? {
        return attributes?.fileSize()
    }
    
    ///The creation data of the item
    public var createdAt: NSDate? {
        return attributes?.fileCreationDate()
    }
    
    ///The error of the last operation
    public var lastError: NSError?
    
    ///Initilizer with path
    public required init(path: PathType) {
        self.path = path
    }
    
    ///Initilize with raw path
    public convenience init(_ raw: String) {
        self.init(path: Path(raw))
    }
    
    ///Delete the item on the disk
    public func delete() -> Bool {
        return fileManager.removeItemAtPath(path.raw, error: &lastError)
    }
    
    ///Check if the item exists on the disk
    public func exits() -> Bool {
        return fileManager.fileExistsAtPath(self.path.raw)
    }
    
    ///Rename the item on the disk
    public func rename(toName: String) -> Bool {
        var components = path.components
        components[components.count-1] = toName
        let newPath = Path(components: components)
        
        return move(newPath)
    }
    
    ///Move the item to the given path on the disk
    public func move(toPath: PathType) -> Bool {
        let succeeded = fileManager.moveItemAtPath(path.raw, toPath: toPath.raw, error: &lastError)
        
        if succeeded {
            path = toPath
        }
        
        return succeeded
    }
    
    ///Copy the content to a file at the given path
    public func copy(toPath: PathType) -> Bool {
        let succeeded = fileManager.copyItemAtPath(path.raw, toPath: toPath.raw, error: &lastError)
        
        if succeeded {
            path = toPath
        }
        
        return succeeded
    }
}

///Make the item printable
extension Item : Printable {
    
    public var description: String {
        return path.raw
    }
}

///Check if both items are equal
func ==(lhs: ItemType, rhs: ItemType) -> Bool {
    return lhs.path == rhs.path
}

///Check if both items are different
func !=(lhs: ItemType, rhs: ItemType) -> Bool {
    return lhs.path != rhs.path
}
