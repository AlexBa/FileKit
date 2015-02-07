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
    public class var user: Directory? {
        if let user = Path.user {
            return Directory(path: user)
        }
        
        return nil
    }
    
    ///The applications directory
    public class var applications: Directory? {
        if let applications = Path.applications {
            return Directory(path: applications)
        }
        
        return nil
    }
    
    ///The user's home directory
    public class var home: Directory? {
        if let home = Path.home {
            return Directory(path: home)
        }
        
        return nil
    }
    
    ///The user's desktop directory
    public class var desktop: Directory? {
        if let desktop = Path.desktop {
            return Directory(path: desktop)
        }
        
        return nil
    }
    
    ///The user's trash directory
    public class var trash: Directory? {
        if let trash = Path.trash {
            return Directory(path: trash)
        }
        
        return nil
    }
    
    ///The user's music directory
    public class var music: Directory? {
        if let music = Path.music {
            return Directory(path: music)
        }
        
        return nil
    }
    
    ///The user's movies directory
    public class var movies: Directory? {
        if let movies = Path.movies {
            return Directory(path: movies)
        }
        
        return nil
    }
    
    ///The user's documents directory
    public class var documents: Directory? {
        if let documents = Path.documents {
            return Directory(path: documents)
        }
        
        return nil
    }
    
    ///The user's downloads directory
    public class var downloads: Directory? {
        if let downloads = Path.user {
            return Directory(path: downloads)
        }
        
        return nil
    }
    
    ///The user's library directory
    public class var library: Directory? {
        if let library = Path.library {
            return Directory(path: library)
        }
        
        return nil
    }
    
    ///The user's shared public directory
    public class var shared: Directory? {
        if let shared = Path.shared {
            return Directory(path: shared)
        }
        
        return nil
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
    
    ///Count the amounts of items
    public func count() -> Int? {
        return fileManager.contentsOfDirectoryAtPath(path.raw, error: &lastError)?.count
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
}