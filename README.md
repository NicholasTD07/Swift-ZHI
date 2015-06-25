# SwiftDaily-ZhiHu

iOS ZhiHuDaily client, implemented in Swift.

<img src="https://dl.dropboxusercontent.com/u/212792226/SwiftDaily-ZhiHu-1.2.0.gif" alt="Showcase GIF" width="320">

## Features

### Basics

Basic functionality that the official App offers.

* show a list of latest daily news from Zhihu's API - DailyView
 * infinite scrolling
* show news content in a detail view - NewsView

### Planned

Features I would like to add:

* show contributors(author + recommenders) in NewsView
* offline storage/cache
 * news list items
 * news content

## Setup

```sh
brew install carthage
bin/setup
```

### Minimum Requirement for Build Environment

* Xcode 7.0 beta
* Swift 2.0

## Frameworks

* [Realm]     - Offline storage

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

The official App can do lots of things, e.g. load the latest news, show detail news content, likes and comments, etc. However, it is missing some features that I would like to have. It also tracks user behaviour and gives this information to a third party company in China.

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
