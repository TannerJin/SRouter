# [SRouter](https://tannerjin.github.io/2019/11/04/SRouter/)
An iOS(Swift) Router to resolve references between modules and don't need registered router.    

[原理(Base on Exported Symbol)](https://tannerjin.github.io/2019/11/04/SRouter/)

## Usage

1. 

```swift
/*
    Login Module
*/
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

/*
    Any Others Module
*/
SRouterManager.default.routeTo("Login.login")?(navi: naviController, title: "登录🚀🚀🚀", others: "Any others params...")
```

2. 
```swift
/*
   Login Module
*/
public func loginActionTestDefault(_ params: [String: Any]) -> [String: Any]? {
    print("Hello, loginActionTestDefault;", params)
    return nil
}

/*
    Any Others Module
*/
let routerSymbol = "Login.loginActionTestDefault(Swift.Dictionary<Swift.String, Any>) -> Swift.Optional<Swift.Dictionary<Swift.String, Any>>"

SRouterManager.default.routeTo(routerSymbol)?(param1: "hello", param2: 1024)

// will print `Hello, loginActionTestDefault; ["param1": "hello", "param2", 1024]`
```

3. 

```swift
/*
    Login Module
*/
public func LoginActionTest(a: Int, b: UIViewController) {
    print("Hello, LoginActionTest; inputValue =", a, b)
}

/*
    Any Others Module
*/
let routerSymbol = "Login.LoginActionTest(a: Swift.Int, b: __C.UIViewController) -> ()"
if let action = SRouterManager.default.routeTo(routerSymbol, routerSILFunctionType: (@convention(thin) (Int, UIViewController)->()).self) {
     action(1024, UIViewController())
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
SRouterManager.default.routeAndHandleNotFound("Login.404-Test")
```

Use Yourself Hander

```swift
SRouterManager.default.routeAndHandleNotFound("Login.404-Test") {
    print("Login.404-Test Router is not found")            
}
```


### Log

```swift
// open
SRouterManager.openLog()
 
// close
SRouterManager.closeLog()
```


