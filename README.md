# FileKit

FileKit is the easy way to handle all your files and directories on the disk. Build on top of the NSFileManager and with pure swift, it's all you need to build great apps.

## Get Started

At first you have to import the framework into your project. All you need to do is to write a simple import statement.
```swift
import FileKit
```

## Examples

### Create a file
```swift
var file = File("~/Desktop/test.txt")
file.create()
file.content = "Just a test!"
```

### Create a directory
```swift
var directory = Directory("~/Documents/cat.png")
var root = Directory.root
var home = Directory.home?
var applications = Directory.applications?
var music = Directory.music?
var movies = Directory.movies?
// And many more...
```

### Handle Paths
```swift
var pathToRoot = Path("/") 
var directory = Directory(path: pathToRoot)

var pathToImage = Path.home.child("pictures/funny-cat.png")
var file = File(path: pathToImage)
```

### List the content of the home directory
```swift
if var items = Directory.home?.content {
for item in items {
println(item.name)
}
}
```

### Todo's

- Write Unit Tests

### License
FileKit is a private project and it's not allowed to share any code without the permission of the project owner. 

### Contact
- Alexander Barton (alexander.barton@cipher-bits.com)
