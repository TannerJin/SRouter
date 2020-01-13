# [SRouter](https://tannerjin.github.io/2019/11/04/SRouter/)
An iOS(Swift) Router to resolve references between modules and don't need registered router


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

or

SRouterManager.presentRouter("User.OtherViewController", by: self, animated: true)

```

2. init(nibName:bundle:)

```swift
// router to UserInfoViewController of User Module

if let controller = SRouterManager.initNibController("User.UserInfoViewController", nibName: nil, bundle: nil) {
    self.navigationController?.pushViewController(controller, animated: true)
}

OR

SRouterManager.pushNibRouter("User.UserInfoViewController", nibName: nil, bundle: nil, by: self.navigationController, animated: true)

```

### Error Hander

#### Not Found(404)

Registered Default Hander for 404

```swift
SRouterManager.default.registeredDefultNotFoundHandler { router in
    print("\(router) Error: 404")
}
```

Use Default Hander

```swift
SRouterManager.default.routeAndHandleNotFound("Login://404-Test")
```

Use Yourself Hander

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


