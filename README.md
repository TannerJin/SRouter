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


1. init()

Any Modules

```swift
// router to OtherViewController of User Module
if let controller = SRouterManager.initController("User.OtherViewController") {
    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}
```

2. init(nibName:bundle:)

Any Modules

```swift
// router to OtherViewController of User Module
if let controller = SRouterManager.initNibController("User.UserInfoViewController", nibName: nil, bundle: nil) {
    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}
```

3. init(_ param1: Int, param2: String, ...)

User Module

```swift
class OtherViewController: UIViewController {
    
    var _title: String?
    
    // @inline(never) must add
    @inline(never) init(_: String) {
        super.init(nibName: nil, bundle: nil)
        self._title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

Any Others Modules

```swift
typealias OtherViewControllerInitMethod = @convention(thin) (String) -> UIViewController

if let controller =  SRouterManager.unsafeInitController("User.OtherViewController", initMethodType: OtherViewControllerInitMethod.self)(_: String.self)?("Other🚀🚀🚀") {

    self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
}
```
