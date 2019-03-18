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

@IBDesignable open class ProgressBarView: UIView {
    let layerTagKey = "tag"
    
    let smallIconSize: CGFloat = 32
    let bgImageViewTag = 334
    let iconLayerTag = 335
    let progressLayerTag = 336
    
    let smallProgressInset = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
    let middleProgressInset = UIEdgeInsets(top: 12, left: 34, bottom: 12, right: 34)
    let bigProgressInset = UIEdgeInsets(top: 22, left: 60, bottom: 22, right: 60)
    
    private var progress: CGFloat = 0
    
    @IBInspectable var withIcon: Int = 0

    @IBInspectable open var style: Int = 0 {
        didSet {
            self._style = ProgressViewStyle(rawValue: style) ?? .small
        }
    }
    
    // Icon only for style == ProgressViewStyle.small
    @IBInspectable open var icon: Int = 0 {
        didSet {
            self._icon = ProgressViewIcon(rawValue: icon) ?? .tele
        }
    }
    
    private var _style: ProgressViewStyle = .small {
        didSet {
            configureStyle()
        }
    }
    private var _icon: ProgressViewIcon = .tele
    
    func setProgress(_ progress: CGFloat, animated: Bool = false, duration: CGFloat = 0.2) {
        self.progress = progress
        
        guard let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView,
            let progressLayerView = bgImageView.viewWithTag(progressLayerTag) as? UIImageView else { return }

        let inset: UIEdgeInsets
        
        switch _style {
        case .small:
            inset = smallProgressInset
        case .middle:
            inset = middleProgressInset
        case .big:
            inset = bigProgressInset
        }
        
        let elementFrame: CGRect = bgImageView.layer.bounds
        let finalFrame = CGRect(x: inset.left, y: inset.top, width: (elementFrame.size.width - inset.left - inset.right) * progress, height: elementFrame.size.height - inset.top - inset.bottom)
        
        UIView.animate(withDuration: TimeInterval(animated ? duration : 0.0), delay: 0.0, options: .curveLinear, animations: {
            progressLayerView.frame = finalFrame
        })
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    func configureIcon() {
        guard let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView, withIcon > 0 else { return }
        
        let image: UIImage?
        
        switch _icon {
        case .hypno:
            image = R.image.hypnoPBIcon()
        case .summon:
            image = R.image.summonPBIcon()
        case .chaos:
            image = R.image.chaosPBIcon()
        case .tele:
            image = R.image.telePBIcon()
        }
        
        var iconLayer: CALayer? = nil
        
        for layer in bgImageView.layer.sublayers ?? [] {
            let tag: Int = (layer.value(forKey: layerTagKey) as? NSNumber)?.intValue ?? 0
            
            if tag == iconLayerTag {
                iconLayer = layer
                break
            }
        }
        
        if iconLayer == nil {
            iconLayer = CALayer()
            iconLayer?.backgroundColor = UIColor.clear.cgColor
            iconLayer?.setValue(NSNumber(value: iconLayerTag), forKey: layerTagKey)
            iconLayer?.frame = CGRect(x: smallIconSize / 2, y: (bgImageView.frame.size.height - smallIconSize) / 2.0, width: smallIconSize, height: smallIconSize)
            
            if let iconLayer = iconLayer {
                bgImageView.layer.addSublayer(iconLayer)
            }
        }
        
        iconLayer?.contents = image?.cgImage
    }
    
    func configureProgress() {
        guard let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView else { return }
        
        var progressLayerView = bgImageView.viewWithTag(progressLayerTag) as? UIImageView
        var image: UIImage? = nil
        
        let inset: UIEdgeInsets
        
        switch _style {
        case .small:
            image = R.image.pbSmallProgress()
            inset = smallProgressInset
            
            configureIcon()
        case .middle:
            image = R.image.pbMiddleProgress()
            inset = middleProgressInset
        case .big:
            image = R.image.pbBigProgress()
            inset = bigProgressInset
        }
        
        if progressLayerView == nil {
            progressLayerView = UIImageView()
            progressLayerView?.backgroundColor = UIColor.clear
            progressLayerView?.tag = progressLayerTag
            
            if let progressLayerView = progressLayerView {
                bgImageView.addSubview(progressLayerView)
            }
        }
        
        let elementFrame: CGRect = bgImageView.bounds
        
        progressLayerView?.frame = CGRect(x: inset.left, y: inset.top, width: elementFrame.size.width - inset.left - inset.right, height: elementFrame.size.height - inset.top - inset.bottom)
        
        progressLayerView?.image = image
    }
    
    func configureStyle() {
        guard let bgImageView = viewWithTag(bgImageViewTag) as? UIImageView, bgImageView.image == nil else { return }
        
        var image: UIImage? = nil
        
        switch _style {
        case .small:
            image = R.image.pbSmall()
            configureIcon()
        case .middle:
            image = R.image.pbMiddle()
        case .big:
            image = R.image.pbBig()

        }
        
        bgImageView.image = image
        
        configureProgress()
    }
    
    func initialize() {
        clipsToBounds = false
        backgroundColor = UIColor.clear
        let bgImageView = UIImageView(frame: .zero)
        bgImageView.clipsToBounds = false
        bgImageView.backgroundColor = UIColor.clear
        bgImageView.tag = bgImageViewTag
        addSubview(bgImageView)
        
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: bgImageView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        })
        
        bgImageView.contentMode = .scaleToFill
    }
}
