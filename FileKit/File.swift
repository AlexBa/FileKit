//
//  File.swift
//  FileKit
//
//  Created by Alexander Barton on 07.02.15.
//  Copyright (c) 2015 CipherBits. All rights reserved.
//

import Foundation

public class File : Item {
    
    ///Check if the file is readable
    public var readable: Bool {
        return fileManager.isExecutableFileAtPath(path.raw)
    }
    
    ///Check if the file is writeable
    public var writeable: Bool {
        return fileManager.isWritableFileAtPath(path.raw)
    }
    
    ///Check if the file is executable
    public var executable: Bool {
        return fileManager.isExecutableFileAtPath(path.raw)
    }
    
    ///Get the file type
    public var type: String {
        return path.raw.pathExtension
    }
    
    ///Modifiy the content of the file
    public var content: String? {
        get {
            return read()
        }
        set(newContent) {
            if newContent != nil {
                write(newContent!)
            } else {
                delete()
            }
        }
    }
    
    ///Create the file with an empty content
    public func create() -> Bool {
        return write("")
    }
    
    ///Read the contenr of the file
    public func read(encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        return String(contentsOfFile: path.raw, encoding: NSUTF8StringEncoding, error: &lastError)
    }
    
    ///Write the string into the file
    public func write(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        return string.writeToFile(path.raw, atomically: false, encoding: encoding, error: &lastError)
    }
    
    ///Append the string onto the content of the file
    public func append(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return appendData(data)
        }
        
        return false
    }
    
    ///Read the content of the file
    public func readData() -> NSData? {
        if readable {
            return fileManager.contentsAtPath(path.raw)
        }
        
        return nil
    }
    
    ///Write the data into the file
    public func writeData(data: NSData) -> Bool {
        if writeable {
            return fileManager.createFileAtPath(path.raw, contents: data, attributes: attributes)
        }
        
        return false
    }
    
    ///Append the data onto the content of the file
    public func appendData(data: NSData) -> Bool {
        if writeable {
            if let fileUrl = NSURL.fileURLWithPath(path.raw) {
                if exits() {
                    if let fileHandle = NSFileHandle(forWritingToURL: fileUrl, error: &lastError) {
                        fileHandle.seekToEndOfFile()
                        fileHandle.writeData(data)
                        fileHandle.closeFile()
                        return true
                    }
                
                    return false
                }
            
                return writeData(data)
            }
        }
        
        return false
    }
}
