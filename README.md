## Heroes

![Test](https://github.com/abbasmousavi/Heroes/workflows/Test/badge.svg?branch=master)

Heroes is an app to search Marver Database of superheroes, written in `Swift` 4.1, and tested on iOS 11 and 12.

I have tried to use a simple, clean, extendable and testable structure for the project. When the app starts running, It initializes the store and the service and injects them to `NavigationController` initializer. I have used a `UINavigationController` as the navigation "coordinator". In larger projects, each flow can have its own coordinator, and it is not required to be a subclass of `UINavigationController`, having a reference to view controllers is enough to present, push or show other view controllers. This coordinator act as the delegate of all view controllers in the flow and is responsible for pushing or presenting view controllers and transitions between them.

I have defined a simple custom transition between characters `HeroesListViewController` and `HeroDetailsViewController`. I have defined `DestinationOfAnimatedTransition` and `SourceOfAnimatedTransition` protocols to pass the required data for doing animation from view controllers to the transition class. Currently, it just animates between two `UIImageViews` but using the same structure more complex data can be passed to the transition class and more complex transition animation can be done. It is a pluggable mechanism, just by adding or deleting the extension that conforms view controllers to one of this two protocols, you can change the transition from default to custom and back.

So the `NavigationController` initializes `HeroesListViewController` by injecting required dependencies, presents it and acts as its delegate and decides which view controller should be presented next, according to user actions that come to it through `HeroesListViewControllerProtocol`. When the user taps a character in the list, `NavigationController` initializes `HeroDetailsViewController` and manages the transition to present it.

I have used view control containment to keep view controllers small and clean. For example in the list view, `HeroesListViewController` is responsible for managing the search bar and getting data from network service and communicating with `NavigationController` and the child `HeroListController` is a `UITableViewController` responsible for displaying the data in the table view and acting as its delegate. In `HeroDetailsViewController`, I have used `EmbeddedListViewController` as the child. It is a generic view controller that can get a list of items conforming to `Listable` protocol (I.e having a title and a thumbnail) and display them in a collection view.

For the favorites feature, I don't include a separate list of favorite characters, because of task definition, I just added UI elements to the list and detail views, but a separate list of favorite characters can be added simply by reusing `HeroListController`. For persisting favorites, I have used a `Store` protocol. I have implemented an example store, `FileStore`, that saves favorite items to a file on disk on receiving `UIApplicationWillTerminate` notificaton. Controllers access the store through `ServiceProtocol`. Other implementations of the `Store` protocol can be injected to store favorite items in SQLite, Realm, iCould or CoreData or for testing purpose.

For downloading images from the network, I have used a subclass of `UIImageView` that keeps a reference to the related `URLSessionDataTask`. I have used `ImageIO` for more performant decoding, `NSCache` for caching decoded images and standard `NSURLSession` cache for caching request response. Many improvements and optimizations can be done on this mechanism, for example managing the number of simultaneous requests, managing the cache size or using a better cache.

Because of the limited time that I had for working on the task, I have not included many tests. I have included 3 UI tests that test the main user stories and some unit tests for `FileStore` that test the functionality of `FileStore` and also encoding and decoding of model classes. A good type of tests for this project is snapshot tests, we can make a `FakeService` class conforming to `ServiceProtocol` that reads data from some files instead of network and then inject this class to view controllers and check snapshots of some UI components.

## Screenshots

![List Screenshot](https://gitlab.com/abbasmousavi/Heroes/raw/master/Screenshots/List.png)
![Details Screenshot](https://gitlab.com/abbasmousavi/Heroes/raw/master/Screenshots/Details.png)
