# [SRouter](https://tannerjin.github.io/2019/11/04/SRouter/)
An iOS(Swift) Router to resolve references between modules and don't need registered router

[原理](https://tannerjin.github.io/2019/11/04/SRouter/)

## Usage

* 

Login Module
```swift
// define login router
@_silgen_name("Login.login")
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
SRouterManager.default.routeTo("Login.login")?(navi: naviController, title: "登录🚀🚀🚀", others: "Any others params...")
```

*

Login Module

```swift
// define Interface
public func LoginActionTest(a: Int, b: UIViewController) {
    print("Hello, LoginActionTest; inputValue =", a, b)
}
```

Any Others Module

```swift
if let action = SRouterManager.default.routeTo("Login.LoginActionTest(a: Swift.Int, b: __C.UIViewController) -> ()",   routerSILFunctionType: (@convention(thin) (Int, AnyObject)->()).self) {
     action(996, self)
}
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


