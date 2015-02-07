//
//  Path.swift
//  FileKit
//
//  Created by Alexander Barton on 01.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public protocol PathType {
    
    ///The raw path to the item
    var raw: String { get set }
    
    ///The path's components
    var components: [String] { get }
    
    ///Initializer with raw path
    init(_ raw: String)
    
    ///Initializer with path components
    init(components: [String])
    
    ///The path to the parent folder
    func parent() -> PathType?
    
    ///Create a new path out of the current path and the given child
    func child(path:String) -> PathType
}

public class Path : PathType {
    
    ///The path to the root directory
    public class var root: Path {
        return Path("/")
    }
    
    ///The path to the user's user directory
    public class var user: Path {
        return Path.search(.UserDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the applications directory
    public class var applications: Path {
        return Path.search(.AllApplicationsDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's home directory
    public class var home: Path {
        return Path.search(.DocumentDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's desktop directory
    public class var desktop: Path {
        return Path.search(.DesktopDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's trash directory
    public class var trash: Path {
        return Path.search(.TrashDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's music directory
    public class var music: Path {
        return Path.search(.MusicDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's movies directory
    public class var movies: Path {
        return Path.search(.MoviesDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's documents directory
    public class var documents: Path {
        return Path.search(.DocumentDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's downloads directory
    public class var downloads: Path {
        return Path.search(.DownloadsDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's library directory
    public class var library: Path {
        return Path.search(.LibraryDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///The path to the user's shared public directory
    public class var shared: Path {
        return Path.search(.SharedPublicDirectory, domainMask: .UserDomainMask).first!
    }
    
    ///Search for specific paths
    public class func search(directory: NSSearchPathDirectory, domainMask: NSSearchPathDomainMask, expandTilde: Bool = true) -> [Path] {
        var rawPaths = NSSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde) as [String]
        
        var paths = [Path]()
        for rawPath in rawPaths {
            paths.append(Path(rawPath))
        }
      
        return paths
    }
    
    ///Raw path to the item
    public var raw: String
    
    ///The path's components
    public var components: [String] {
        return raw.pathComponents
    }
    
    ///Initializer with raw path
    public required init(_ raw: String){
        self.raw = raw
    }
    
    ///Initializer with path components
    public required init(components: [String]) {
        raw = "/".join(components)
    }
   
    ///The path to the parent folder
    public func parent() -> PathType? {
        if self != Path.root || raw != "" {
            // Remove the last path component
            var components = raw.pathComponents
            components.removeLast()
            var path = "/".join(components);
            path = dropFirst(path) // Remove the slash at the beginning
            
            return Path(path);
        }
        
        return nil
    }
    
    ///Create a new path out of the current path and the given child path
    public func child(path: String) -> PathType {
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
