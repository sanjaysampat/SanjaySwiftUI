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
    * JSON service with Codable protocol
        * Loading and updating JSON service response. 
        * **Pending to make for nested JSON**
        * Saving json in document folder
        * Loading again the same from document folder, so no flicker on screen
        * Testing by loading jsons with multiple image urls to test loading and background saving ( continued )
    * Loading UIViewControllers via UIViewControllerRepresentable in SwiftUI
        * Use Coordinator to handle delegates
        * to pass .constant as @Binding vars for SwiftUI PreviewProvider
    * Add custom storyboard in SwiftUI project and communication with it via UIViewControllerRepresentable
    * PersonPhotoImagePickerViewController from camera and gallery via UIViewControllerRepresentable. This is creating UI with code using UIKit
    * Use Photo Editor ( earlier version swift ) via UIViewControllerRepresentable. This is using UI with storyboard
    * ~~Custom AlertControlView via UIViewControllerRepresentable for getting 'name' text from user.~~ (not in use)
    * 'alertSS' functions to call custom alerts with textfield.
    * 'View' extension to print debug messages with PrintView method.
    * Integration / modification of Views created by 'Chris Mash' project [AVPlayer-SwiftUI](https://github.com/ChrisMash/AVPlayer-SwiftUI) for Audio play functionality integration at bottom of LIstView
        * List refill on shuffle array of songs.
        * Add/delete single item to core data in second audio list.
        * Added play/pause button in Audio
        * Continuing how to create proper observers of AVPlayer.
            * Issue while adding more observers.
            * 'SourceKitService" and/or 'Swift' process on mac taking max memory, so xcode and all mac proccesses slogs to halt ( macOS Catalina 10.15.6, tried on XCode 11.6 and 11.5)
    * Added Navigation view - 'Menu' option in content view.
    * Tabview added with Localizable Strings files for ગુજરાતી and मराठी display in tab.
    * Apple Pay test integration
        * Buy with various Landmark items. 
            * Saving Landmark data in document folder after buying, to store status of 'bought' 
            * Loading the landmark json from document folder if available ( or from bundle )
            * 'Clear all Bought data'
                * Local JSON file deleted.
                * When reloading the landmark data with load() method, view promptly refreshed 'bought' text.
        * Set different shipping options with shipping charges
            * EBook category with email shippingContactFields only
            * PaymentSummaryItem 'Shipping' charges for Lakes
            * 0 amount product without shipping charges.
    * Set landmark item as 'bought' 
        * temporary both for success/fail
        * used filteredLandMark and 'firstIndex' to find the index of record, to modify it.
        * It is always better to pass id's of struct array (insted of object). We can get index of it to modify the record.
        * alerts tested in Apple pay list view.
    
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
    
####### Note:- Replace 'PrivateCommit' with 'PublicCommit' to run. 

