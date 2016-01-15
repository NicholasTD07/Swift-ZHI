# SwiftDaily-ZhiHu

iOS ZhiHuDaily client, implemented in Swift.

No need to wait for the loading screen of any News you'd like to read. You can
save it first before you read it. It will be there for you.

If you are reading ZhiHuDaily outside of China, the loading time for the content
of a News is about 3-5 seconds.  And on average a user reads 7-10 news a day.

See [here](#user-content-there-is-already-an-official-zhihudaily-app-why-another) for detailed reason why I create this App.

<img src="https://dl.dropboxusercontent.com/u/212792226/SwiftDaily-ZhiHu-1.2.0.gif" alt="Showcase GIF" width="320">

## Features

### Basics

Basic functionality that the official App offers.

* Show a list of latest daily news from Zhihu's API - DailyView
 * Infinite scrolling
* Show news content in a detail view - NewsView

### Features I added

* Offline storage/cache by using [Realm]
 * News list items - [`NewsMetaObject`](./SwiftDaily-ZhiHu/Models/RealmModels.swift)
 * News content    - [`NewsObject`](./SwiftDaily-ZhiHu/Models/RealmModels.swift)

### Planned

#### Features I would like to add:

* Show info about News in DailyView
 * Author's name
 * Total number of likes
 * Total number of comments
* Show contributors(author + recommenders) in NewsView

## Setup

```sh
gem install cocoapods
pod install
```

### Minimum Requirement for Build Environment

* Xcode 7.2
* Swift 2.1

## Frameworks

* [Realm] - Offline storage

### [SwiftDailyAPI]

Framework I write to help myself building this App and possibly an Mac version
of this App, also to help people who may want to build one themselves.

#### Using

* [Alamofire] - Elegant HTTP networking
* [Argo]      - Functional JSON parsing
* [Quick]     - Testing
* [Nimble]    - Matcher

## Documentation

* [Use Protocol as Function Parameter in Swift](http://dev.nicktd.com/tldr/2015/06/08/use-protocol-in-swift-as-function-parameter.html)

### Planned

* ZhiHuDaily's API
* How to use mitmproxy to reverse engineer an App's API
* Using Core Data with Swift and Protocol

## Q&A

### About the branch model for `git`

* master        - stable release
* develop       - mainly developing on this branch
* experiment/   - testing things I am not sure whether it will work out or not
* feature/      - building features

### There is already an official ZhihuDaily App. Why another?

The official App can do lots of things, e.g. load the latest news, show detail news content, likes and comments, etc.

However, it is missing some features that I would like to have.

For example, as I mentioned at the top, because of network latency it takes
about 3-5 seconds to load the content of a News, if you are using the official
App outside of China. And I hate waiting. It's a waste of my time and my life. I
want to be able to save multiple News' contents before I read it so that I don't
have to wait for the loading screen. This is the main reason why I made this
App, to save time and life, mine and also others'.

Another thing is that the official App also tracks user behaviour and gives this
information to a third party company in China. I just don't like it.

## APPENDIX

### ZhiHu

From Wikipedia:
"Zhihu" is a Chinese question-and-answer website. It has a similar product model as Quora.
<br>
[link to wiki page](http://en.wikipedia.org/wiki/Zhihu)

### ZhihuDaily

Daily highly-rated answers in ZhiHu, which are picked by editors.

### Previous Version

[DailyNews](https://github.com/NicholasTD07/ios-playgrounds/tree/all-merged/ios8-restkit-zhihu)

Screeshot:

![Daily App Showcase GIF](https://dl.dropboxusercontent.com/u/212792226/zhihu-daily-v1-take-3.gif)

[Alamofire]: https://github.com/Alamofire/Alamofire
[Argo]: https://github.com/thoughtbot/Argo
[Quick]: https://github.com/Quick/Quick
[Nimble]: https://github.com/Quick/Nimble
[SwiftDailyAPI]: https://github.com/NicholasTD07/SwiftDailyAPI
[Realm]: https://realm.io
