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
    
    ///The user's user directory
    public class var user: Directory {
        return Directory(path: Path.user)
    }
    
    ///The applications directory
    public class var applications: Directory {
        return Directory(path: Path.applications)
    }
    
    ///The user's home directory
    public class var home: Directory {
        return Directory(path: Path.home)
    }
    
    ///The user's desktop directory
    public class var desktop: Directory {
        return Directory(path: Path.desktop)
    }
    
    ///The user's trash directory
    public class var trash: Directory {
        return Directory(path: Path.trash)
    }
    
    ///The user's music directory
    public class var music: Directory {
        return Directory(path: Path.music)
    }
    
    ///The user's movies directory
    public class var movies: Directory {
        return Directory(path: Path.movies)
    }
    
    ///The user's documents directory
    public class var documents: Directory {
        return Directory(path: Path.documents)
    }
    
    ///The user's downloads directory
    public class var downloads: Directory {
        return Directory(path: Path.downloads)
    }
    
    ///The user's library directory
    public class var library: Directory {
        return Directory(path: Path.library)
    }
    
    ///The user's shared public directory
    public class var shared: Directory {
        return Directory(path: Path.shared)
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