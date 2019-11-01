# SRouter
An iOS(Swift) Router to resolve references between modules and don't need registered router

SwiftRouter, StubRouter, SymbolRouter, whatever just call SRouter


## Usage

### Route To Function

Login Module
```swift
// define login router
@_silgen_name("Login://login")
public func LoginRouterInterface(with params: [String: Any]) -> [String: Any]? {
    guard let navi = params["navi"] as? UINavigationController else {
       return nil
    }
    
    let loginController = LoginViewController()
    if let title = params["title"] as? String {
        loginController._title = title
    }
    navi.pushViewController(loginController, animated: true)
    return nil
}

```

Any Others Module

```swift
// router to login of Login Module
SRouterManager.default.routeTo("Login://login")?(navi: naviController, title: "登录🚀🚀🚀", others: "Any others params...")
```

### Route To UIViewController

Please make sure your ViewController hasn't yourself init method    

Otherwise, you can use **[Route To Function](#route-to-function)** to init ViewController

1. init()

```swift
// router to OtherViewController of User Module

if let controller = SRouterManager.initController("User.OtherViewController") {
    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}
```

2. init(nibName:bundle:)

```swift
// router to UserInfoViewController of User Module

if let controller = SRouterManager.initNibController("User.UserInfoViewController", nibName: nil, bundle: nil) {
    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}
```

### Error Hander

#### Not Found(404)

##### Registered 404 hander
you can registered one default hander for 404

```swift
SRouterManager.default.registeredDefultNotFoundHandler { router in
    print("\(router) Error: 404")
}
```

##### Use 404 Hander

use registered hander
```swift
SRouterManager.default.routeAndHandleNotFound("Login://404-Test")
```

use yourself hander
```swift
SRouterManager.default.routeAndHandleNotFound("Login://404-Test") {
    print("Login://404-Test Router is not found")            
}
```


### Log

```swift
// open
SRouterManager.openLog()
 
// close
SRouterManager.closeLog()
```


