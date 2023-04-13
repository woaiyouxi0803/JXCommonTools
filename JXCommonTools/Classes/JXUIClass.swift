import UIKit

// MARK: - window
public struct JXWindow {
    
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
}




// MARK: - UILabel
/// 带边距的label
class JXInsetsLabel: UILabel {
    
    var jx_insets: UIEdgeInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        if jx_insets != UIEdgeInsets.zero {
            super.drawText(in: rect.inset(by: jx_insets))
            return
        }
        super.drawText(in: rect)
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
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


// MARK: - UISlider
class JXSlider: UISlider {
    /// 高度
    var jxHeight = 0.0
    /// 较大值侧的图片
    var jxGreatIV: UIImageView? {
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
    func jx_setPoint(left: Int64, right: Int64) {
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
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return jxHeight == 0 ?
        super.trackRect(forBounds: bounds) :
            .init(x: bounds.origin.x, y: (frame.size.height - jxHeight)/2.0, width: bounds.size.width, height: jxHeight)
    }
    
    
    override func layoutSubviews() {
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



// MARK: - UICollectionViewFlowLayout
/// 单行显示完整时居中，注意方向
class JXCenterFlowLayout: UICollectionViewFlowLayout {
    
    /// false时每个间隔不变为minimumLineSpacing
    var jx_is_averageSpacing = true
    
    private var jx_reLayoutAttri = false
    private var jx_attri = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
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
    
    
    func setVerticalAttri(_ count: Int, _ fSize: CGSize) {
        
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
    
    func setHorizontalAttri(_ count: Int, _ fSize: CGSize) {
        
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
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return jx_reLayoutAttri ? jx_attri : super.layoutAttributesForElements(in: rect)
    }
    
}
    
