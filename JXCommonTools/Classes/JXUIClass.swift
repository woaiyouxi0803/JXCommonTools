import UIKit
import SnapKit
import Hue

// MARK: - window
public struct JXWindow {
    
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    public static var currentViewController: UIViewController? {
        return _topVC(keyWindow?.rootViewController)
    }
    
    private static func _topVC(_ vc: UIViewController?) -> UIViewController? {
        if vc is UINavigationController {
            return _topVC((vc as? UINavigationController)?.topViewController)
        } else if vc is UITabBarController {
            return _topVC((vc as? UITabBarController)?.selectedViewController)
        } else {
            return vc
        }
    }
    
    /// 从类名获取类
    public static func jx_classFrom(className: String) -> AnyClass? {
        guard let ns = Bundle.main.infoDictionary!["CFBundleName"] as? String else {
            print("not found CFBundleName")
            return nil }
        guard let cl = NSClassFromString(ns + "." + className) else {
            print("not found class:" + className)
            return nil }
        return cl
    }
    
}




// MARK: - UILabel
/// 带边距的label
public class JXInsetsLabel: UILabel {
    
    public var jx_insets: UIEdgeInsets = UIEdgeInsets.zero
    
    public override func drawText(in rect: CGRect) {
        if jx_insets != UIEdgeInsets.zero {
            super.drawText(in: rect.inset(by: jx_insets))
            return
        }
        super.drawText(in: rect)
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        if jx_insets != UIEdgeInsets.zero {
            rect.origin.x -= jx_insets.left;
            rect.origin.y -= jx_insets.top;
            rect.size.width += (jx_insets.left + jx_insets.right);
            rect.size.height += (jx_insets.top + jx_insets.bottom);
        }
        return rect
    }
}


// MARK: - toast
public class JXTipLabel: JXInsetsLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.75)
        textColor = .white
        font = UIFont.systemFont(ofSize: 12)
        numberOfLines = -1
        layer.cornerRadius = 5
        layer.masksToBounds = true
        tag = 20230512;
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @discardableResult
    public static func jx_show(text: String?, duration: TimeInterval, sview: UIView? = nil, labelTextInsets: UIEdgeInsets = .init(top: 16, left: 22, bottom: 16, right: 22), widthMargins: CGFloat = 44) -> JXTipLabel? {
        var superView: UIView?
        if sview != nil {
            superView = sview!
        } else {
            superView = JXWindow.keyWindow
        }
        
        self.cancelPreviousPerformRequests(withTarget: self, selector: #selector(jx_end), object: superView)
        
        guard let superView = superView else { return nil }
        let label = superView.viewWithTag(20230512) as? JXTipLabel ?? JXTipLabel()

        label.jx_insets = labelTextInsets
        label.frame = .zero
        label.text = (text?.utf8.count ?? 0 == 0) ? " " : text
        label.sizeToFit()
        
        if label.frame.size.width + widthMargins * 2 > superView.frame.size.width {
            label.frame = .init(x: 0, y: 0, width: superView.frame.size.width - widthMargins * 2, height: superView.frame.size.height)
            label.sizeToFit()
        }
        let h = label.frame.size.height
        let w = label.frame.size.width
        
        label.frame = .init(x: (superView.bounds.size.width - w)/2.0, y: (superView.bounds.size.height - h)/2.0, width: w, height: h)
        superView.addSubview(label)
        label.isHidden = false
        
        self.perform(#selector(jx_end), with: superView, afterDelay: duration)
        
        return label
    }

    @objc public static func jx_end(_ sview: UIView?) {
        
        let label = sview?.viewWithTag(20230512)
        label?.isHidden = true
        label?.removeFromSuperview()
        
    }

}


// MARK: - UISlider
public class JXSlider: UISlider {
    /// 高度
    public var jxHeight = 0.0
    /// 较大值侧的图片
    public var jxGreatIV: UIImageView? {
        willSet {
            if newValue == nil {
                jxGreatIV?.removeFromSuperview()
                if hadLabel {
                    jxLeftLabel.frame = .init(x: 6 , y: 0, width: jxLeftLabel.bounds.size.width, height: bounds.size.height)
                    jxRightLabel.frame = .init(x: (bounds.size.width - jxRightLabel.bounds.size.width - 6 ), y: 0, width: jxRightLabel.bounds.size.width, height: bounds.size.height)
                }
            } else {
                addSubview(newValue!)
            }
        }
    }
    
    private var hadLabel = false
    public func jx_setPoint(left: Int64, right: Int64) {
        hadLabel = true
        if jxLeftLabel.superview == nil {
            addSubview(jxLeftLabel)
        }
        if jxRightLabel.superview == nil {
            addSubview(jxRightLabel)
        }
        
        if left == 0 &&
            right == 0 {
            value = 0.5
        } else {
            value = Float((Float(left) / Float(left + right)))
        }
        
        jxLeftLabel.text = String(left)
        jxRightLabel.text = String(right)
        
        jxLeftLabel.sizeToFit()
        jxRightLabel.sizeToFit()
    }
    
    lazy var jxLeftLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "PingFangSC-Semibold", size: 10)
        view.textColor = .white
        view.textAlignment = .left
        return view
    }()
    
    lazy var jxRightLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "PingFangSC-Semibold", size: 10)
        view.textColor = .white
        view.textAlignment = .right
        return view
    }()
    
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return jxHeight == 0 ?
        super.trackRect(forBounds: bounds) :
            .init(x: bounds.origin.x, y: (frame.size.height - jxHeight)/2.0, width: bounds.size.width, height: jxHeight)
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        jx_layoutGreatIV()
        jx_layoutLabel()
    }
    
    private func jx_layoutGreatIV() {
        if jxGreatIV == nil {
            return
        }
        
        if value == 0.5 {
            jxGreatIV?.isHidden = true
            return
        }
        
        jxGreatIV?.isHidden = false
        guard let bound = jxGreatIV?.bounds else { return }
        if value > 0.5 {
            jxGreatIV?.frame = .init(x: 0, y: (frame.size.height - bound.size.height)/2.0 , width: bound.size.width, height: bound.size.height)
        } else {
            jxGreatIV?.frame = .init(x: (frame.size.width - bound.size.width), y: (frame.size.height - bound.size.height)/2.0 , width: bound.size.width, height: bound.size.height)
        }
    }
    
    private func jx_layoutLabel() {
        guard hadLabel == true else {
            return
        }
        
        let leftE: CGFloat
        let rightE: CGFloat
        
        if jxGreatIV?.isHidden ?? true == true {
            leftE = 0.0
            rightE = 0.0
        } else {
            leftE = value < 0.5 ? 0.0 : CGRectGetMaxX(jxGreatIV!.frame)
            rightE = value < 0.5 ? (bounds.size.width - jxGreatIV!.frame.origin.x) : 0.0;
        }
        
        jxLeftLabel.frame = .init(x: 6 + leftE, y: 0, width: jxLeftLabel.bounds.size.width, height: bounds.size.height)
        jxRightLabel.frame = .init(x: (bounds.size.width - jxRightLabel.bounds.size.width - 6 - rightE), y: 0, width: jxRightLabel.bounds.size.width, height: bounds.size.height)
    }
    
}


// MARK: - JXAlertView
public class JXAlertView: UIControl {
    
    public var jx_autoRemove = true
    
    var clickBlock: ((_ index: Int, _ alert: JXAlertView)->())?
    
    public lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        view.textAlignment = .center
        view.numberOfLines = -1
        view.textColor = UIColor(hex: "#1A1A1A")
        return view
    }()
    
    public lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "PingFangSC-Medium", size: 14)
        view.textAlignment = .center
        view.numberOfLines = -1
        view.textColor = UIColor(hex: "#1A1A1A")
        return view
    }()
    
    public lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 14)
        view.setTitle("取消", for: .normal)
        view.setTitleColor(.init(hex: "#666666"), for: .normal)
        view.setBackgroundImage(.jx_image(color: .init(hex: "#E4E7F0"), size: .init(width: 120, height: 38), corners: .allCorners, radius: 19), for: .normal)
        view.addTarget(self, action: #selector(jx_CancelButtonClick), for: .touchUpInside)
        return view
    }()
    
    public lazy var confirmButton: UIButton = {
        let view = UIButton(type: .custom)
        view.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 14)
        view.setTitle("确认", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.setBackgroundImage(.jx_gradient([UIColor(hex: "#F474A3"), UIColor(hex: "#EF90ED")], size: .init(width: 120, height: 38), radius: 19, locations: nil, direction: .leftOblique), for: .normal)
        view.addTarget(self, action: #selector(jx_ConfirmButtonClick), for: .touchUpInside)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() {
        backgroundColor = .black.withAlphaComponent(0.5)
        addTarget(self, action: #selector(JXAlertViewClick), for: .touchUpInside)
        
        addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(messageLabel)
        bgView.addSubview(cancelButton)
        bgView.addSubview(confirmButton)
        
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(290)
        }
        
    }
    
    // MARK: - 点击事件
    @objc fileprivate func JXAlertViewClick() {
        clickBlock?(0, self)
        if (jx_autoRemove) {
            removeFromSuperview()
        }
    }
    
    @objc fileprivate func jx_CancelButtonClick() {
        clickBlock?(-1, self)
        removeFromSuperview()
    }

    @objc fileprivate func jx_ConfirmButtonClick() {
        clickBlock?(1, self)
        removeFromSuperview()
    }
    
    // MARK: - 设置文案
    fileprivate func jx_Set(title: String?, message: String?, cancelTitle: String?, confirmTitle: String?) {
        titleLabel.text = title
        messageLabel.text = message
        cancelButton.setTitle(cancelTitle, for: .normal)
        confirmButton.setTitle(confirmTitle, for: .normal)
        
        let showButton = (confirmTitle?.utf16.count ?? 0 > 0 ||
                          cancelTitle?.utf16.count ?? 0 > 0 )
        
        if (title?.utf16.count ?? 0 == 0) {
            layoutTextOnlyMessage(showButton)
        } else if (message?.utf16.count ?? 0 == 0) {
            layoutTextOnlyTitle(showButton)
        } else {
            layoutTextDefault(showButton)
        }
        
        if (showButton == false) {
            layoutButtonNone()
            return
        }
        if (cancelTitle?.utf16.count ?? 0 == 0) {
            layoutButtonOnlyConfirm()
            return
        }
        if (confirmTitle?.utf16.count ?? 0 == 0) {
            layoutButtonOnlyCancel()
            return
        }
        layoutButtonDefault()
    }
    
    
    // MARK: - 标题和内容布局
    fileprivate func layoutTextDefault(_ showButton: Bool = true) {
        if titleLabel.superview == nil {
            bgView.addSubview(titleLabel)
        }
        if messageLabel.superview == nil {
            bgView.addSubview(messageLabel)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(25)
        }

        messageLabel.snp.remakeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.bottom.equalTo(showButton == true ? -83: -30)
        }
    }
    
    fileprivate func layoutTextOnlyTitle(_ showButton: Bool = true) {
        messageLabel.removeFromSuperview()
        if titleLabel.superview == nil {
            bgView.addSubview(titleLabel)
        }
        titleLabel.snp.remakeConstraints { make in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(25)
            make.bottom.equalTo(showButton == true ? -83: -30)
        }
    }

    fileprivate func layoutTextOnlyMessage(_ showButton: Bool = true) {
        titleLabel.removeFromSuperview()
        if messageLabel.superview == nil {
            bgView.addSubview(messageLabel)
        }
        messageLabel.snp.remakeConstraints { make in
            make.leading.equalTo(40)
            make.trailing.equalTo(-40)
            make.top.equalTo(25)
            make.bottom.equalTo(showButton == true ? -83: -30)
        }
    }

    
    // MARK: - 按钮布局
    fileprivate func layoutButtonDefault() {
        if cancelButton.superview == nil {
            bgView.addSubview(cancelButton)
        }
        if confirmButton.superview == nil {
            bgView.addSubview(confirmButton)
        }

        cancelButton.snp.remakeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
            make.leading.equalTo(17)
            make.bottom.equalTo(-15)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
            make.trailing.equalTo(-17)
            make.bottom.equalTo(-15)
        }
    }
    
    fileprivate func layoutButtonOnlyCancel() {
        confirmButton.removeFromSuperview()
        if cancelButton.superview == nil {
            bgView.addSubview(cancelButton)
        }
        cancelButton.snp.remakeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
    }
    
    fileprivate func layoutButtonOnlyConfirm() {
        cancelButton.removeFromSuperview()
        if confirmButton.superview == nil {
            bgView.addSubview(confirmButton)
        }
        
        confirmButton.snp.remakeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(38)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
        }
    }
    
    fileprivate func layoutButtonNone() {
        cancelButton.removeFromSuperview()
        confirmButton.removeFromSuperview()
    }
    
}



extension JXAlertView {
    
    @discardableResult
    /// 按文字有无自动布局弹窗
    /// - Parameters:
    ///   - toView: 展示到哪个view上，nil为window上
    ///   - title: 粗体标题
    ///   - message: 内容
    ///   - block: 点击blcok。-1左边、0其他部位、1右边（判断大于0）
    ///   - cancelTitle: 左边标题 （nil则不展示）
    ///   - confirmTitle: 右边标题 （nil则不展示）
    ///   - jx_autoRemove: 点击背景是否自动移除
    /// - Returns: 弹窗本体，nil则没有弹出
    public static func jx_show(toView: UIView?, title: String?, message: String?, block: ((_ index: Int, _ alert: JXAlertView)->())? ,cancelTitle: String? = "取消", confirmTitle: String? = "确认", jx_autoRemove: Bool = true) -> JXAlertView? {
        guard let onView = (toView == nil) ? JXWindow.keyWindow : toView else {
            print("[JXAlertView]未找到展示到哪")
            return nil
        }
        
        guard (title?.utf16.count ?? 0 > 0 ||
               message?.utf16.count ?? 0 > 0) else {
            print("[JXAlertView]没有展示内容")
            return nil
        }
        
        let alertView = JXAlertView(frame: UIScreen.main.bounds)
        alertView.jx_autoRemove = jx_autoRemove
        alertView.clickBlock = block
        alertView.jx_Set(title: title, message: message, cancelTitle: cancelTitle, confirmTitle: confirmTitle)
        
        onView.addSubview(alertView)
        return alertView
    }

    
}



// MARK: - UICollectionViewFlowLayout
/// 单行显示完整时居中，注意方向
public class JXCenterFlowLayout: UICollectionViewFlowLayout {
    
    /// false时每个间隔不变为minimumLineSpacing
    public var jx_is_averageSpacing = true
    
    private var jx_reLayoutAttri = false
    private var jx_attri = [UICollectionViewLayoutAttributes]()
    
    public override func prepare() {
        super.prepare()
        guard let cv = collectionView else {
            jx_reLayoutAttri = false
            return }
        let count = cv.numberOfItems(inSection: 0)
        if count == 0 {
            jx_reLayoutAttri = false
            return
        }
       
        if scrollDirection == .vertical {
            setVerticalAttri(count, cv.frame.size)
            return
        }
        setHorizontalAttri(count, cv.frame.size)
    }
    
    
    private func setVerticalAttri(_ count: Int, _ fSize: CGSize) {
        
        let hight = fSize.height
        let ih = itemSize.height
        let tempY = (hight - CGFloat(count) * ih - CGFloat(count - 1) * minimumLineSpacing)/2.0
        jx_reLayoutAttri = (tempY > 0)
        if (jx_reLayoutAttri == false) {
            return
        }
        
        
        let topY: CGFloat
        let minSpacing: CGFloat
        if jx_is_averageSpacing == true {
            topY = (hight - CGFloat(count) * ih) / CGFloat(count + 1)
            minSpacing = topY
        } else {
            topY = tempY
            minSpacing = minimumLineSpacing
        }
            
        let leadingX = (fSize.width - itemSize.width) / 2.0
        jx_attri.removeAll()
        
        for i in 0..<count {
            let att = UICollectionViewLayoutAttributes(forCellWith: .init(row: i, section: 0))
            let y: CGFloat
            if i == 0 {
                y = topY
            } else {
                y = topY + CGFloat(i) * (ih + minSpacing)
            }
            
            att.frame = .init(x: leadingX, y: y, width: ih, height: itemSize.height)
            jx_attri.append(att)
        }
            
    }
    
    private func setHorizontalAttri(_ count: Int, _ fSize: CGSize) {
        
        let width = fSize.width
        let iw = itemSize.width
        let tempX = (width - CGFloat(count) * iw - CGFloat(count - 1) * minimumLineSpacing)/2.0
        jx_reLayoutAttri = (tempX > 0)
        if (jx_reLayoutAttri == false) {
            return
        }
        
        
        let leadingX: CGFloat
        let minSpacing: CGFloat
        if jx_is_averageSpacing == true {
            leadingX = (width - CGFloat(count) * iw) / CGFloat(count + 1)
            minSpacing = leadingX
        } else {
            leadingX = tempX
            minSpacing = minimumLineSpacing
        }
            
        let topY = (fSize.height - itemSize.height) / 2.0
        jx_attri.removeAll()
        
        for i in 0..<count {
            let att = UICollectionViewLayoutAttributes(forCellWith: .init(row: i, section: 0))
            let x: CGFloat
            if i == 0 {
                x = leadingX
            } else {
                x = leadingX + CGFloat(i) * (iw + minSpacing)
            }
            
            att.frame = .init(x: x, y: topY, width: iw, height: itemSize.height)
            jx_attri.append(att)
        }
            
    }
    
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return jx_reLayoutAttri ? jx_attri : super.layoutAttributesForElements(in: rect)
    }
    
}
    
