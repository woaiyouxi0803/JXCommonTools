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

`JXSlider`:可以设置高度的UISlider。
`var jxHeight`设置高度。
`func jx_setPoint(left: Int64, right: Int64)`:可以左右两边设置显示数值
`var jxGreatIV: UIImageView?`设置后会在数值大的一侧展示该UIImageView
![./pic/JXSlider.png](https://github.com/woaiyouxi0803/JXCommonTools/blob/main/pic/JXSlider.png?raw=true)

`JXAlertView`
弹窗参考，根据文字有无自动重新布局

```
public static func jx_show(toView: UIView?, title: String?, message: String?, block: ((_ index: Int, _ alert: JXAlertView)->())? ,cancelTitle: String? = "取消", confirmTitle: String? = "确认", jx_autoRemove: Bool = true) -> JXAlertView? {
```




`JXCenterFlowLayout`: 单行/列，根据数量，自动均分居中的瀑布流布局。



---

## JXUIExt

`extension UIView`
`jx_add_keyBoard_frame_notifi``jx_remove_keyBoard_frame_notifi`:添加/移除键盘高度改变frame通知
`jx_addPanGestureRecognizer`给view添加可拖拽手势

UI设计尺寸：
`extension Double`:
`public var jx_design: Double `: ✖️屏幕宽/375.0
`public var jx_Hdesign: Double `: ✖️屏幕高/667.0

时间秒/毫秒转换：
`extension Int64``extension TimeInterval`:
`public var jx_to_second: TimeInterval` 时间戳统一秒/毫秒都转为秒
`public var jx_to_millisecond: TimeInterval`时间戳统一秒/毫秒都转为毫秒

Array/Dictionary转String：
`extension Array``extension Dictionary`:
`public func jx_toJSONString() -> String? `

`extension JSONSerialization`:
`public static func jx_toJSONString(_ obj: Any) -> String?`



