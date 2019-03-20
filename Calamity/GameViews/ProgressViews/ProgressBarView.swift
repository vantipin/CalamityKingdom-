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
    let smallIconAspect = CGFloat(16) / CGFloat(13)
    
    let iconLayerTag = 335
    
    let smallProgressInset = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
    let middleProgressInset = UIEdgeInsets(top: 12, left: 34, bottom: 12, right: 34)
    let bigProgressInset = UIEdgeInsets(top: 22, left: 60, bottom: 22, right: 60)
    
    private lazy var backgroundView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = backgroundColor
        return view
    }()
    
    private lazy var progressLayerView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = backgroundColor
        return view
    }()
    
    private var progress: CGFloat = 0
    
    @IBInspectable var withIcon: Bool = false

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
    
    func progressInset() -> UIEdgeInsets {
        switch _style {
        case .small:
            return smallProgressInset
        case .middle:
            return middleProgressInset
        case .big:
            return bigProgressInset
        }
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool = false, duration: CGFloat = 0.2) {
        self.progress = progress

        let inset = progressInset()
        
        let elementFrame: CGRect = backgroundView.layer.bounds
        let finalFrame = CGRect(x: inset.left, y: inset.top, width: (elementFrame.size.width - inset.left - inset.right) * progress, height: elementFrame.size.height - inset.top - inset.bottom)
        
        UIView.animate(withDuration: TimeInterval(animated ? duration : 0.0), delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else { return }
            self.progressLayerView.frame = finalFrame
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
    
    func viewsDictionary() -> [String : Any] {
        let viewsDictionary = [
            "backgroundView" : backgroundView,
            "progressLayerView" : progressLayerView
        ]
        
        var viewsMutableDictionary: [String : Any] = [:]
        
        viewsDictionary.forEach { (key, obj) in
            viewsMutableDictionary[key.replacingOccurrences(of: "self.", with: "")] = obj
        }
        
        return viewsMutableDictionary
    }
    
    func viewMetrics() -> [String : Any]? {
        let inset = progressInset()
        
        return [
            "leftPadding": NSNumber(value: Float(inset.left)),
            "rightPadding": NSNumber(value: Float(inset.right)),
            "topPadding": NSNumber(value: Float(inset.top)),
            "botPadding": NSNumber(value: Float(inset.bottom)),
            "fvHeight": NSNumber(value: Float(progressViewHeight()))
        ]
    }
    
    func progressViewHeight() -> CGFloat {
        let inset = progressInset()
        return backgroundView.bounds.size.height - inset.top - inset.bottom
    }
    
    func configureIcon() {
        guard withIcon else { return }
        
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
        
        for layer in backgroundView.layer.sublayers ?? [] {
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
            iconLayer?.frame = CGRect(x: smallIconSize / 2, y: (backgroundView.frame.size.height - smallIconSize) / 2.0, width: smallIconSize, height: smallIconSize)
            
            if let iconLayer = iconLayer {
                backgroundView.layer.addSublayer(iconLayer)
            }
        }
        
        iconLayer?.contents = image?.cgImage
    }
    
    func configureProgress() {
        var image: UIImage? = nil
        
        switch _style {
        case .small:
            image = R.image.pbSmallProgress()
            configureIcon()
        case .middle:
            image = R.image.pbMiddleProgress()
        case .big:
            image = R.image.pbBigProgress()
        }
        
        progressLayerView.image = image
    }
    
    func configureStyle() {
        guard backgroundView.image == nil else { return }
        
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
        
        backgroundView.image = image
        
        configureProgress()
    }
    
    func initialize() {
        clipsToBounds = false
        backgroundColor = UIColor.clear
        addSubview(backgroundView)
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: backgroundView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        })
        
        backgroundView.addSubview(progressLayerView)
        
        let inset = progressInset()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: progressLayerView, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: inset.top),
            NSLayoutConstraint(item: progressLayerView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -inset.bottom),
            NSLayoutConstraint(item: progressLayerView, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: inset.left),
//            NSLayoutConstraint(item: progressLayerView, attribute: .width, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0)
            ])
    }
}
