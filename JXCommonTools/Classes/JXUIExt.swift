import UIKit

/// 拖拽 / 键盘通知位置
extension UIView {
    
    // MARK: - 键盘位置(给frameView添加)
    private struct AssociatedKey {
        static var jx_keyBoard_origin_frame: String = "jx_keyBoard_origin_frame"
    }
    
    private var jx_keyBoard_origin_frame: CGRect {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.jx_keyBoard_origin_frame, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let object = objc_getAssociatedObject(self, &AssociatedKey.jx_keyBoard_origin_frame) as? CGRect ?? .zero
            self.jx_keyBoard_origin_frame = object
            return object
        }
    }
    
    /// 需要提前设置frame
    @discardableResult
    public func jx_add_keyBoard_frame_notifi(_ ae: Bool = false) -> UITapGestureRecognizer? {
        self.jx_keyBoard_origin_frame = self.frame
        NotificationCenter.default.addObserver(self, selector: #selector(jx_keyBoard_willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(jx_keyBoard_willHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard ae == true else { return nil}
        isUserInteractionEnabled = true
        let tap = (UITapGestureRecognizer(target: self, action: #selector(jx_endEditing)))
        addGestureRecognizer(tap)
        return tap
    }
    
    public func jx_remove_keyBoard_frame_notifi() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func jx_endEditing() {
        self.endEditing(true)
    }
    
    @objc private func jx_keyBoard_willShow(_ notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval)

        UIView.animate(withDuration: duration, animations: {
            self.frame = .init(x: self.frame.origin.x, y: UIScreen.main.bounds.size.height - keyboardRect.size.height - self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
        })
    }
    
    @objc private func jx_keyBoard_willHidden(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval)
        UIView.animate(withDuration: duration, animations: {
            self.frame = self.jx_keyBoard_origin_frame
        })
    }

    
    
    
    // MARK: - 拖拽
    @discardableResult
    public func jx_addPanGestureRecognizer() -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(jx_pan_response(_:)))
        pan.delaysTouchesBegan = true
        addGestureRecognizer(pan)
        return pan
    }
    
    
    @objc private func jx_pan_response(_ pan: UIPanGestureRecognizer) {
        guard let superview = superview else {
            return
        }
        let point1 = pan.translation(in: superview)
        var center1 = CGPoint(x: center.x + point1.x, y: center.y + point1.y)
        
        
        
        if pan.state == .began ||
            pan.state == .changed {
            center = center1
        } else if pan.state == .ended {
            let minX1 = bounds.size.width/2.0
            let maxX1 = superview.bounds.size.width - bounds.size.width/2.0
            
            let minY1 = bounds.size.height/2.0 + superview.safeAreaInsets.top
            let maxY1 = superview.bounds.size.height - bounds.size.height/2.0 - superview.safeAreaInsets.bottom
            
            if center1.x < minX1 {
                center1 = .init(x: minX1, y: center1.y)
            } else if center1.x > maxX1 {
                center1 = .init(x: maxX1, y: center1.y)
            }
            
            if center1.y < minY1 {
                center1 = .init(x: center1.x, y: minY1)
            } else if center1.y > maxY1 {
                center1 = .init(x: center1.x, y: maxY1)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.center = center1
            }
        }
        
        pan.setTranslation(.zero, in: self)
    }
    
    
}




// MARK: - Found
extension UIImage {
    
    /// 生成指定尺寸的纯色图像
    static func jx_image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        return jx_image(color: color, size: size, corners: .allCorners, radius: 0)
    }
    
    /// 生成指定尺寸和圆角的纯色图像
    static func jx_image(color: UIColor, size: CGSize, corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if radius > 0 {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            color.setFill()
            path.fill()
        } else {
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    enum GradientDirection {
        case horizontal // 水平从左到右
        case vertical // 垂直从上到下
        case leftOblique // 左上到右下
        case rightOblique // 右上到左下
        case other(CGPoint, CGPoint)

        public func jx_point(size: CGSize) -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
            case .vertical:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
            case .leftOblique:
                return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
            case .rightOblique:
                return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
            case let .other(stat, end):
                return (stat, end)
            }
        }
    }

    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    static func jx_gradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations: [CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return jx_gradient(hexsString.map { UIColor(hex: $0) }, size: size, locations: locations, direction: direction)
    }

    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    static func jx_gradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [CGFloat]? = nil, direction: GradientDirection = .horizontal) -> UIImage? {
        return jx_gradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }

    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    static func jx_gradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations: [CGFloat]? = nil,
                         direction: GradientDirection = .horizontal) -> UIImage?
    {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return UIImage.jx_image(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map { $0.cgColor } as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.jx_point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension Array {
    public func jx_toJSONString() -> String? {
        return JSONSerialization.jx_toJSONString(self)
    }
}

extension Dictionary {
    public func jx_toJSONString() -> String? {
        return JSONSerialization.jx_toJSONString(self)
    }
}

extension JSONSerialization {
    public static func jx_toJSONString(_ obj: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: obj) else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
