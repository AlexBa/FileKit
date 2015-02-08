//
//  Directory.swift
//  FileKit
//
//  Created by Alexander Barton on 01.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public class Directory : Item {

    ///The content of the directory
    public var content: [Item]? {
        if !exits() {
            return nil
        }
        
        var result = [Item]()
        let content = fileManager.contentsOfDirectoryAtPath(path.raw, error: &lastError) as? [String]
        
        if content?.count > 0 {
            for name in content! {
                let path = Path("\(self.path)/\(name)")
                
                var isDirectory: ObjCBool = false
                if fileManager.fileExistsAtPath(path.raw, isDirectory: &isDirectory) {
                    
                    if isDirectory {
                        result.append(Directory(path: path))
                    } else {
                        result.append(File(path: path))
                    }
                }
            }
        }
        
        return result
    }
    
    ///Count the amount of items
    public var count: Int? {
        return fileManager.contentsOfDirectoryAtPath(path.raw, error: &lastError)?.count
    }

    ///Create a new directory on the disk
    public func create(intermediate: Bool = true) -> Bool {
        return fileManager.createDirectoryAtPath(
            path.raw,
            withIntermediateDirectories: intermediate,
            attributes: nil,
            error: &lastError
        )
    }
    
    ///Add a new sub file
    public func createSubFile(name: String) -> File? {
        if exits() {
            let path = self.path.child(name)
            let file = File(path: path)
            file.create()
            
            return file
        }
        
        return nil
    }
    
    ///Add a new sub directory
    public func createSubDirectory(name: String) -> Directory? {
        if exits() {
            let path = self.path.child(name)
            let directory = Directory(path: path)
            directory.create()
            
            return directory
        }
        
        return nil
    }
    
    ///Get the child directory
    public func child(path: String) -> Directory {
        let childPath = self.path.child(path)
        return Directory(path: childPath)
    }
    
    ///Add the item into the directory
    public func add(item: ItemType, copy: Bool = false) -> Bool {
        
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
    public func get(name: String) -> Item? {
        let itemPath = Path("\(path)/\(name)")
        let item = Item(path: itemPath)
        
        if item.exits() {
            return item
        }
        
        return nil
    }
    
    ///Remove an item by name from the directory
    public func remove(name: String) -> Item? {
        if let item = get(name) {
            item.delete()
            return item
        }
    
        return nil
    }
}

extension Directory {
    
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
}