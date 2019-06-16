# training-ios

Just a training for understand how to start to build an iOS app.

## TODOs

- [x] Create iOS app project
- [ ] Storyboard
  - [x] Draw UI components
    - [x] text, label, button, simple components
    - [ ] checkbox or radio button
    - [ ] image
    - [ ] navigation or menu or settings
    - [ ] modals or confirmation
    - [ ] calendar
  - [x] Constraints for auto layout
  - [ ] i18n
- [ ] View controller
  - [x] Simple actions
    - [x] map label and text field to properties
    - [x] simple button actions
    - [ ] checkbox or radio button
  - [ ] Modals or other complex components
- [ ] Animation or transition
- [ ] Complex layout
  - [ ] split files or modular
- [ ] App status
  - [ ] store in memory
  - [ ] fetch from a server
  - [ ] save to files
  - [ ] retrieve from files
- [ ] Make backup
  - [ ] by iCloud?
  - [ ] by send a email

## Summary Up

### UI 绘制 Basic

iOS 应用主要组成文件：

- `AppDelegate.swift` -> 委派模式定义 App 生命周期钩子；
- `ViewController.swift` -> 视图层控制器，控制视图元素的动作；
- `Main.storyboard` -> 故事板，UI 布局。

App 生命周期钩子用来在 App 切换状态时执行一些需要的操作，可用的生命周期分别是 App 启动后、App 进入后台前后、App 从后台进入前台前后和 App 退出时。文件注释中有详细解释。

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {}

func applicationWillResignActive(_ application: UIApplication) {}

func applicationDidEnterBackground(_ application: UIApplication) {}

func applicationWillEnterForeground(_ application: UIApplication) {}

func applicationDidBecomeActive(_ application: UIApplication) {}

func applicationWillTerminate(_ application: UIApplication) {}
```

绘制 UI 的步骤分两步：第一步在 `Main.storyboard` 中拖拽绘制所需的 UI 元素，使用 Constraints 给视图层的元素声明制约，让视图可以自适应设备；绘制完成后第二步就是将 UI 元素和 `ViewController.swift` 控制器关联，定义 UI 元素的动作。

故事板是一个 xml 文件，还好不需要手写，Xcode 提供一套可视化操作流程帮助我们绘制 UI，但是感觉限制还是很多。等 SwiftUI 的声明式 UI 出来就好了。

UI 的绘制通过从 Library 中拖拽需要的元素到视图层上实现，UI 元素的位置尽量设置为相对的，通过设定 Constraint 可以让 UI 元素在一个设定条件下适应不同设备和不同方向。设定 Constraint 时首先将需要自动布局的元素嵌入到 StackView 元素。初步简单布局后结果如下。

```text
View Controller Scene
    ▽ View Controller
        ▽ View
            - Safe Area
            ▽ Stack View
                - Label
                - Text Field
                - Button
                ▽ Constraints
                    - trailing = Text Field.trailing
            ▽ Constraints
                - Safe Area.trailing = Stack View.trailing + 20
                - Stack View.leading = Safe Area.leading + 20
                - Stack View.top = Safe Area.top + 20
    ▷ First Responder
    ▷ Exit
    → Storyboard Entry Point
```

简单的 UI 绘制暂且完成，要将 UI 元素关联到 Source 中，首先在侧边打开 `ViewController.swift` 文件，用 `control` 键配合鼠标拖拽元素到控制器文件的某一行，做一个映射。如果是文本框或者标签元素会映射一个属性，如果是按钮我们选择 type 为 UIButton 类型，让其映射为对按钮类型起效的动作。

```swift
import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var todoNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Actions
    @IBAction func changeLabelText(_ sender: UIButton) {
        // set to default if text field does not have a value
        if nameTextField.text == "" {
            todoNameLabel.text = "TODOs"
        } else {
            todoNameLabel.text = nameTextField.text
        }
    }

}
```

上面我定义按钮的动作为将用户输入的文本框值作为标签名显示，如果用户没有输入则显示默认的标签名。

看到映射的 property 会标注 `@IBOutlet` 属性，编译器看到这个属性就知道这是一个映射对象，映射一个 UI 元素。为了避免强引用循环，这里使用弱引用来指向 UI 元素，但是使用感叹号标注可选类型则表示在使用时这个属性不是可选的，任何时候访问该属性都是安全的。原因在于顶级的 View Controller 会对这个控制器和所有 UI 项目保持强引用关系，当可以通过这个方法操作 UI 对象时表示初始化已经完成，所有 UI 项目已经存在。

动作方法标注了 `@IBAction` 属性，表示这是一个关联 UI 的动作处理。由于这里设置指定只有 UIButton 类型的元素才能触发，它会接收一个 UIButton 实例作为参数，让我们可以访问到按钮并进行操作。目前看来这是典型的 MVC 结构。

前面说到故事板是一个 xml 文件，通过映射属性和方法到控制器，xml 文件也相应更新了配置，记载映射后的属性名称和方法名称，以此将两个资源关联到一起。实际上这还是一个挺老旧的处理方式，但是由于 xml 编辑过程不需要人工干预，所以体验上还是比较轻松的。但是个人还是偏向于声明式 UI。

### 处理文本框

上面按钮动作使用了 `@IBAction` 属性关联按钮和其在代码中对应的控制器，但是对于文本框处理稍微复杂一点。官方指南中让 `ViewController` 类实现 `UITextFieldDelegate` 协议，让其可以成为一个文本框委派对象使用。

```swift
class ViewController: UIViewController, UITextFieldDelegate {
```

接着在初始化器中设定委派对象为自身。

```swift
nameTextField.delegate = self
```

这样 `ViewController` 就成为了可以处理文本框事件的一个委派对象。文中提到文本框委派对象声明了 8 个事件方法，这次我们需要用到下面两个。

```swift
func textFieldShouldReturn(_ textField: UITextField) -> Bool
func textFieldDidEndEditing(_ textField: UITextField)
```

`textFieldShouldReturn(_:)` 方法在用户点击键盘的回车键时触发。这时我们需要做的是将键盘收回。

```swift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
```

这里直接调用实例的 `resignFirstResponder()` 方法，让实例退出 First Responder 状态，这样键盘就会自动收回了。First Responder 是 iOS 应用中的一个状态概念，如果你熟悉 Web 开发，那么它是类似于 HTML 元素的 focus 状态的，就是当前聚焦的状态。这个方法返回一个布尔值，这个布尔值表示系统是否应该对回车键进行相应的处理，比如跳到下一个文本框等，这里其实 true 或者 false 效果是一样的，应该我们只想收起键盘，没有下一个文本框，但是通常来说我们会返回 true。

接下来我们需要 `textFieldDidEndEditing(_:)` 帮我们在用户结束编辑之后做一些事情。这我将用户输入内容设置为了 Label 名称。

```swift
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoNameLabel.text = textField.text
    }
```

这里我将之前按钮的功能改了，变成只设定默认值，修改后的版本如下。第一次修改时没有使用重构修改导致 xml 方面没有同步更新，为了保持两边同步一定要使用重构选项进行重命名操作。仔细想想这也是没办法的，用户不去触发重构操作，就 IDE 来说如果每次修改自动触发重构反而在资源和正确性上会出很多问题。

```swift
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var todoNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        todoNameLabel.text = textField.text
    }

    //MARK: Actions
    @IBAction func resetLabelName(_ sender: UIButton) {
        todoNameLabel.text = "TODOs"
    }

}
```

现在这个简陋的 App 可以将用户输入的内容设置为 Label 名称，并且用户可以点击按钮恢复 Label 名称的默认值了。

> R：到此为止记录在 [1.iOS UI Basics](https://github.com/zfanli/notes/tree/master/ios/started/1.UIBasics.md)，以方便查阅。
