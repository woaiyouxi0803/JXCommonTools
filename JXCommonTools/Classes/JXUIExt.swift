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
    func jx_add_keyBoard_frame_notifi() {
        self.jx_keyBoard_origin_frame = self.frame
        NotificationCenter.default.addObserver(self, selector: #selector(jx_keyBoard_willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(jx_keyBoard_willHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
                
    }
    
    func jx_remove_keyBoard_frame_notifi() {
        NotificationCenter.default.removeObserver(self)
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
    func jx_addPanGestureRecognizer() -> UIPanGestureRecognizer {
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

            view.safeAreaInsets.
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
