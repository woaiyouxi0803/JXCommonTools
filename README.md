# JXCommonTools

[![CI Status](https://img.shields.io/travis/m1/JXCommonTools.svg?style=flat)](https://travis-ci.org/m1/JXCommonTools)
[![Version](https://img.shields.io/cocoapods/v/JXCommonTools.svg?style=flat)](https://cocoapods.org/pods/JXCommonTools)
[![License](https://img.shields.io/cocoapods/l/JXCommonTools.svg?style=flat)](https://cocoapods.org/pods/JXCommonTools)
[![Platform](https://img.shields.io/cocoapods/p/JXCommonTools.svg?style=flat)](https://cocoapods.org/pods/JXCommonTools)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS13，swift 5.0

## Installation

JXCommonTools is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JXCommonTools'
```

## Author

woaiyouxi0803, woaiyouxi0803@163.com

## License

JXCommonTools is available under the MIT license. See the LICENSE file for more info.

## JXUIClass

`JXWindow.window`: 获取window
`JXWindow.jx_classFrom(className: String) -> AnyClass?`:根据类名获取类

`JXInsetsLabel`：带边距的label`var jx_insets`设置边距

`JXAlertView`:自定义弹窗，根据设置的内容有无自动调整大小
```
        JXAlertView.jx_show(toView: nil, title: "title", message: "message") { index, alert in
            print(index)
        }
        
        let alert = JXAlertView.jx_show(toView: nil, title: "title(jx_autoRemove == false)", message: "message") { index, alert in
            print(index)
        }
        alert?.jx_autoRemove = false
```

`JXSlider`:可以设置高度的UISlider。
`var jxHeight`设置高度。
`func jx_setPoint(left: Int64, right: Int64)`:可以左右两边设置显示数值
`var jxGreatIV: UIImageView?`设置后会在数值大的一侧展示该UIImageView
![./pic/JXSlider.png](https://github.com/woaiyouxi0803/JXCommonTools/blob/main/pic/JXSlider.png?raw=true)

---

## JXUIExt

`extension UIView`
`jx_add_keyBoard_frame_notifi``jx_remove_keyBoard_frame_notifi`:添加/移除键盘高度改变frame通知
`jx_addPanGestureRecognizer`给view添加可拖拽手势

