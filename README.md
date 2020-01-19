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

###  Another Case

Register Module

```swift
// define Interface
@_silgen_name("Login://registered")
public func RegisteredRouterInterface(with param: String) -> UIViewController {
    let registeredController = RegisteredViewController(title: "Registered 🚀🚀🚀")
    registeredController._title = param
    return registeredController
}
```

Any Others Module

```swift
typealias RegisteredRouterSILFunctionType = @convention(thin) (_ input: String) -> UIViewController
        
if let registeredController = SRouterManager.default.routeTo("Login://registered", routerSILFunctionType: RegisteredRouterSILFunctionType.self)?("注册 🚀🚀🚀") {
     self.present(UINavigationController(rootViewController: registeredController), animated: true, completion: nil)
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


