# SRouter
An iOS(Swift) Router Design to solve module reference and don't need register router

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

Any Module

```swift
// router to UserInfoViewController of User Module
if var controller = SRouterManager.default.unsafeRouteToController("User.UserInfoViewController") {
            self.present(UINavigationController(rootViewController: controller.`init`()), animated: true, completion: nil)
        }
```


## Performace Optimization

1. Put the files of 'RouterInterface' in forefront at configure of 'Complile Sources'; Like Shown Below   
![](https://github.com/TannerJin/SRouter/blob/master/images/Performance%20optimization-1.png)   

2. More Modules for the componentization
