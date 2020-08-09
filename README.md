#  SanjaySwiftUI
SwiftUI project creation to learn.

## Version
1.0

### Topics learned

1. SwiftUI project.
    * Test code for ZStack
    * @State variables
        * on modification perform some tasks with the help of Hidden Toggle control
        * on modification change another @State variable
        * the modified @State variables should not run in recursive loops.
    * controls 
        * VStack with rotation effect
        * HStack
        * Button with padding, forgroundColor, logic in 'action', open new view with 'sheet'
        * Rectangle with rotation and scale
        * Image with aspectratio, mask of gradient, scaleEffect
            * logically load UIImage or placeholder image from systemName
            * onReceive - changes published, do some tasks.
            * loading list of filtered images in multiple HStacks on a screen in various sizes.
            * loading image from web URL with cache
    * Multiple SwiftUI views loading from contentView
    * Loading and updating JSON service response with codable protocol. Pending to make for nested JSON
    * Loading UIViewControllers via UIViewControllerRepresentable in SwiftUI
        * Use Coordinator to handle delegates
        * to pass .constant as @Binding vars for SwiftUI PreviewProvider
    * Add custom storyboard in SwiftUI project and communication with it via UIViewControllerRepresentable
    * PersonPhotoImagePickerViewController from camera and gallery via UIViewControllerRepresentable. This is creating UI with code using UIKit
    * Use Photo Editor ( earlier version swift ) via UIViewControllerRepresentable. This is using UI with storyboard
    * Custom AlertControlView via UIViewControllerRepresentable for getting 'name' text from user.
    * 'View' extension to print debug messages with PrintView method.
    
2. GIT integration (Github)
    * Added Project to GIT from XCode 11
    * Creation and Commit to master branch from XCode
    
3. Build project from Github with [Bitrise](https://www.bitrise.io/) in cloud. ( concept is still not clear )

4. Coredata
    * usage of .xcdatamodeld
    * generation of coredataproperties and coredataclass with Editor -> Create NSManagedObject SubClass
    * @FetchRequest of entity
    * saveContext

4. Markdown format for README.md

5. Use of SF Symbols for **systemImage** icons.
    * [System Icons](https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/system-icons/) (iOS12  and Earlier)
    * There are over 1,500 symbols text that can be used in apps running in iOS 13 and later. To browse the full set of symbols, download [the SF Symbols mac app](https://developer.apple.com/design/downloads/SF-Symbols.dmg). 
