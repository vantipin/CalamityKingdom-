//
//  ProgressBarView.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/18/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

@objc enum ProgressViewStyle : Int {
    case small = 0
    case middle
    case big
}

@objc enum ProgressViewIcon : Int {
    case tele = 0
    case summon
    case hypno
    case chaos
}

@IBDesignable
class ProgressBarView: UIView {
    let smallIconSize: CGFloat = 32
    let bgImageViewTag = 334
    let iconLayerTag = 335
    let progressLayerTag = 336
    
    let smallProgressInset = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
    let middleProgressInset = UIEdgeInsets(top: 12, left: 34, bottom: 12, right: 34)
    let bigProgressInset = UIEdgeInsets(top: 22, left: 60, bottom: 22, right: 60)
    
    private var progress: CGFloat = 0
    
    @IBInspectable var withIcon = false

    @IBInspectable var style: Int = ProgressViewStyle.small.rawValue {
        didSet {
            self._style = ProgressViewStyle(rawValue: style) ?? .small
        }
    }
    @IBInspectable var icon: Int = ProgressViewIcon.tele.rawValue {
        didSet {
            self._icon = ProgressViewIcon(rawValue: icon) ?? .tele
        }
    }
    
    private var _style: ProgressViewStyle = .small
    private var _icon: ProgressViewIcon = .tele
    
    func setProgress(_ progress: CGFloat, animated: Bool = false, duration: CGFloat = 0.2) {
        self.progress = progress
        
        let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView
        
        if bgImageView != nil {
            var progressLayerView: UIImageView? = nil
            
            for view in bgImageView?.subviews ?? [] {
                if view.tag == progressLayerTag {
                    progressLayerView = view as? UIImageView
                    break
                }
            }
            
            let inset: UIEdgeInsets
            
            switch _style {
            case .small:
                inset = smallProgressInset
            case .middle:
                inset = middleProgressInset
            case .big:
                inset = bigProgressInset
            }
            
            if progressLayerView != nil {
                let elementFrame: CGRect? = bgImageView?.layer.bounds
                let finalFrame = CGRect(x: inset.left, y: inset.top, width: ((elementFrame?.size.width ?? 0.0) - inset.left - inset.right) * progress, height: (elementFrame?.size.height ?? 0.0) - inset.top - inset.bottom)
                
                UIView.animate(withDuration: TimeInterval(animated ? duration : 0.0), delay: 0.0, options: .curveLinear, animations: {
                    progressLayerView?.frame = finalFrame
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    func configureIcon() {
        let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView
        
        if withIcon && bgImageView != nil {
            let imageName: String
            
            switch _icon {
            case .hypno:
                imageName = "HypnoPBIcon"
            case .summon:
                imageName = "SummonPBIcon"
            case .chaos:
                imageName = "ChaosPBIcon"
            case .tele:
                imageName = "TelePBIcon"
            }
            
            var iconLayer: CALayer? = nil
            
            for layer in bgImageView?.layer.sublayers ?? [] {
                let tag: Int = (layer.value(forKey: "tag") as? NSNumber)?.intValue ?? 0
                
                if tag == iconLayerTag {
                    iconLayer = layer
                    break
                }
            }
            
            if iconLayer == nil {
                iconLayer = CALayer()
                iconLayer?.backgroundColor = UIColor.clear.cgColor
                iconLayer?.setValue(NSNumber(value: iconLayerTag), forKey: "tag")
                iconLayer?.frame = CGRect(x: smallIconSize / 2, y: ((bgImageView?.frame.size.height ?? 0.0) - smallIconSize) / 2.0, width: smallIconSize, height: smallIconSize)
                if let iconLayer = iconLayer {
                    bgImageView?.layer.addSublayer(iconLayer)
                }
            }
            
            let iconImage = UIImage(named: imageName)
            
            iconLayer?.contents = iconImage?.cgImage
        }
    }
    
    func configureProgress() {
        let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView
        
        if bgImageView != nil {
            var progressLayerView: UIImageView? = nil
            var image: UIImage? = nil
            
            let inset: UIEdgeInsets
            
            switch _style {
            case .small:
                image = UIImage(named: "PBSmallProgress")?.stretchableImage(withLeftCapWidth: Int(5.0), topCapHeight: Int(7.5))
                inset = smallProgressInset
                
                configureIcon()
            case .middle:
                image = UIImage(named: "PBMiddleProgress")?.stretchableImage(withLeftCapWidth: Int(5.0), topCapHeight: Int(22.0))
                inset = middleProgressInset
            case .big:
                image = UIImage(named: "PBBigProgress")?.stretchableImage(withLeftCapWidth: Int(5.0), topCapHeight: Int(40.0))
                inset = bigProgressInset
            }
            
            for view in bgImageView?.subviews ?? [] {
                if view.tag == progressLayerTag {
                    progressLayerView = view as? UIImageView
                    break
                }
            }
            
            if progressLayerView == nil {
                progressLayerView = UIImageView()
                progressLayerView?.backgroundColor = UIColor.clear
                progressLayerView?.tag = progressLayerTag
                
                if let progressLayerView = progressLayerView {
                    bgImageView?.addSubview(progressLayerView)
                }
            }
            
            let elementFrame: CGRect? = bgImageView?.bounds
            
            progressLayerView?.frame = CGRect(x: inset.left, y: inset.top, width: (elementFrame?.size.width ?? 0.0) - inset.left - inset.right, height: (elementFrame?.size.height ?? 0.0) - inset.top - inset.bottom)
            
            progressLayerView?.image = image
        }
    }
    
    func configureStyle() {
        let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView
        
        if bgImageView != nil {
            var image: UIImage? = nil
            
            switch _style {
            case .small:
                image = UIImage(named: "PBSmall")?.stretchableImage(withLeftCapWidth: 10, topCapHeight: 13)
                
                configureIcon()
            case .middle:
                image = UIImage(named: "PBMiddle")?.stretchableImage(withLeftCapWidth: 44, topCapHeight: 35)
            case .big:
                image = UIImage(named: "PBBig")?.stretchableImage(withLeftCapWidth: 79, topCapHeight: 52)

            }
            
            bgImageView?.image = image
            
            configureProgress()
        }
    }
    
    func initialize() {
        clipsToBounds = false
        backgroundColor = UIColor.clear
        let bgImageView = UIImageView(frame: bounds)
        bgImageView.clipsToBounds = false
        bgImageView.backgroundColor = UIColor.clear
        bgImageView.tag = bgImageViewTag
        addSubview(bgImageView)
        
        bgImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        bgImageView.contentMode = .scaleToFill
        
        configureStyle()
    }
}
