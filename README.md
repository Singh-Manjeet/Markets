# Markets - User Stories
1. User can see the bitcoin price updates in GBP
2. User can enter units ( in Bitcoin ) and amount ( in GBP )
3. Data gets updated after each 15 seconds.

# Installation guide

* Clone the project
* Open the `Markets.xcworkspace` file

It should work, Otherwise  please do the following:
* Clone the project
* Open `Terminal` and `cd` to the project directory
* Run `pod install`  and then Open the `Markets.xcworkspace` file

## Approach Used
Implemented the complete functionality mentioned in the User Stories.
1. Created an appropriate architecture, i.e. MVVM
2. To enable the User to have latest price updates, implemented auto refresh.  
3. Each module serves their own role and can be tested accordingly. 
4. Added appropriate cocoa pods to have better user experience. 
5. I could have used single Storyboard but i have added individual storyboards. I found this a better solution to work with Routers.
6. Added a few test cases.

## Enhancements : 
- Can include multiple currency support
- Custom View for Bitcoin that can work with multiple screens  


## Swift Language Version Used:
Swift 5

## Xcode Version
Xcode 11.1

## iPhone App:
iPhone Portrait only.

## Pods Used :
Alamofire
EFCountingLabel

- other options were: Swift Package Manager Or Carthage but they have limited support

## Storyboards
The app contains storyboards
