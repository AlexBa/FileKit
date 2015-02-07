//
//  Directory.swift
//  FileKit
//
//  Created by Alexander Barton on 01.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public class Directory : Item {
    
    ///The root directory
    public class var root: Directory {
        return Directory(path: Path.root)
    }
    
    ///The item names of all items
    public var itemNames: [String]? {
        return fileManager.contentsOfDirectoryAtPath(path.raw, error: &lastError) as? [String]
    }
    
    ///All items of the directory
    public var items: [Item]? {
        if itemNames == nil {
            return nil
        }
        
        var temp = [Item]()
        for name in itemNames! {
            
            let itemPath = Path("\(path)/\(name)")
            let item = Item(path: itemPath)
            temp.append(item)
        }
        
        return temp
    }
    
    ///Initilizer with path
    public required init(path: PathType) {
        super.init(path: path)
    }
    
    ///Create a new directory with the given attributes
    public func create(attributes: [NSObject: AnyObject]? = nil, intermediate: Bool = true) -> Bool {
        return fileManager.createDirectoryAtPath(
            path.raw,
            withIntermediateDirectories: intermediate,
            attributes: attributes,
            error: &lastError
        )
    }
    
    ///Get the child directory
    public func child(path: String) -> Directory {
        let childPath = self.path.child(path)
        return Directory(path: childPath)
    }
    
    ///Add the item into the directory
    public func addItem(item: ItemType, copy: Bool = false) -> Bool {
        
        var succeeded = false
        
        // Copy or move the item into the directory
        if copy {
            succeeded = item.copy(path.child(item.name))
        } else {
            succeeded = item.move(path.child(item.name))
        }
        
        if !succeeded {
            lastError = item.lastError
            return false
        }
        
        return true
    }
    
    ///Get the item with the specific name
    public func getItem(#name: String) -> Item? {
        let itemPath = Path("\(path)/\(name)")
        let item = Item(path: itemPath)
        
        if item.exits() {
            return item
        }
        
        return nil
    }
    
    ///Remove the item with the specific name
   /* public func removeItem(#name: String) -> Bool {
        
        
        
        
    }*/
    
    ///Count the amounts of items
    public func count() -> Int? {
        return fileManager.contentsOfDirectoryAtPath(path.raw, error: &lastError)?.count
    }
}