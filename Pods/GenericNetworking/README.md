# GenericNetworking

[![CI Status](http://img.shields.io/travis/alexiscn/GenericNetworking.svg?style=flat)](https://travis-ci.org/alexiscn/GenericNetworking)
[![Version](https://img.shields.io/cocoapods/v/GenericNetworking.svg?style=flat)](http://cocoapods.org/pods/GenericNetworking)
[![License](https://img.shields.io/cocoapods/l/GenericNetworking.svg?style=flat)](http://cocoapods.org/pods/GenericNetworking)
[![Platform](https://img.shields.io/cocoapods/p/GenericNetworking.svg?style=flat)](http://cocoapods.org/pods/GenericNetworking)

## Features

- [x] GET / POST Methods
- [ ] Upload data

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


```swift

class GithubSDK {
    public static func getGists(completion: @escaping GenericNetworkingCompletion<[Gist]>) {
    // response is array of objects
        GenericNetworking.requestJSON(baseURLString: "https://api.github.com", path: "/gists", method: .get, parameters: nil, headers: nil, completion: completion);
    }

    public static func getGistDetail(_ gistId: String, completion: @escaping GenericNetworkingCompletion<Gist>) {
        // response is an object
        let URLString = "https://api.github.com/gists/" + gistId
        GenericNetworking.getJSON(URLString: URLString, completion: completion)
    }
}
```

here you call GithubSDK like following

```swift

GithubSDK.getGists { (response) in
    switch response {
    case .success(let gists):
        print(gists.count)
        for gist in gists {
            print("gist id:\(gist.identifider)")
        }
    case .error(let error):
        print(error)
    }
}
```


## Requirements

* Swift 4.0
* Alamofire

## Installation

GenericNetworking is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GenericNetworking'
```

## Author

alexiscn, shuifengxu@gmail.com

## License

GenericNetworking is available under the MIT license. See the LICENSE file for more info.
