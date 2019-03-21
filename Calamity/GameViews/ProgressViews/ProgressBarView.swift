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
    
    func insets() -> UIEdgeInsets {
        switch self {
        case .small:
            return UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
        case .middle:
            return UIEdgeInsets(top: 12, left: 34, bottom: 12, right: 34)
        case .big:
            return UIEdgeInsets(top: 22, left: 60, bottom: 22, right: 60)
        }
    }
    
    func progressImage() -> UIImage? {
        switch self {
        case .small:
            return R.image.pbSmallProgress()
        case .middle:
            return R.image.pbMiddleProgress()
        case .big:
            return R.image.pbBigProgress()
        }
    }
    
    func bgImage() -> UIImage? {
        switch self {
        case .small:
            return R.image.pbSmall()
        case .middle:
            return R.image.pbMiddle()
        case .big:
            return R.image.pbBig()
        }
    }
}

@objc enum ProgressViewIcon : Int {
    case tele = 0
    case summon
    case hypno
    case chaos
    
    func image() -> UIImage? {
        switch self {
        case .hypno:
            return R.image.hypnoPBIcon()
        case .summon:
            return R.image.summonPBIcon()
        case .chaos:
            return R.image.chaosPBIcon()
        case .tele:
            return R.image.telePBIcon()
        }
    }
}

@IBDesignable open class ProgressBarView: UIView {
    let smallIconAspect = CGFloat(16) / CGFloat(13)
    
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
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = .clear
        iconLoaded = true
        return view
    }()
    
    var name: String = "" {
        didSet {
            guard name.count > 0, withIcon else {
                if oldValue.count > 0 {
                    initialLabel.removeFromSuperview()
                }
                return
            }
            
            initialLabel.text = name
            configureInitialLabel()
        }
    }
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor(red: 1, green: 245 / 255, blue: 202 / 255, alpha: 1)
        label.textAlignment = .left
        
        if let font = R.font.domCasualNormal(size: CGFloat(Int(progressLayerView.bounds.height * 0.9))){
            label.font = font
        }
        
        return label
    }()
    
    var value: String = "" {
        didSet {
            guard value.count > 0, withIcon else {
                if oldValue.count > 0 {
                    finalLabel.removeFromSuperview()
                }
                return
            }
            
            finalLabel.text = value
            configureFinalLabel()
        }
    }
    
    private lazy var finalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .white
        label.textAlignment = .left
        
        if let font = R.font.domCasualNormal(size: CGFloat(Int(progressLayerView.bounds.height * 0.9))){
            label.font = font
        }
        
        return label
    }()
    
    private var iconLoaded = false
    
    private var progressWidthConstraint: NSLayoutConstraint? = nil
    private var progress: CGFloat = 0
    
    @IBInspectable var withIcon: Bool = false {
        didSet {
            if _style == .small {
                configureIcon()
            } else if iconLoaded {
                iconView.removeFromSuperview()
            }
        }
    }

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

        if let progressConstraint = progressWidthConstraint {
            progressConstraint.constant = progressViewWidth()
        }
        
        UIView.animate(withDuration: TimeInterval(animated ? duration : 0.0), delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
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
    
    private func progressViewHeight() -> CGFloat {
        let insets = _style.insets()
        return backgroundView.bounds.size.height - insets.top - insets.bottom
    }
    
    private func progressViewWidth() -> CGFloat {
        let insets = _style.insets()
        return (backgroundView.bounds.size.width - insets.left - insets.right) * progress
    }
    
    func configureFinalLabel() {
        guard finalLabel.superview == nil, withIcon else { return }
        self.backgroundView.addSubview(finalLabel)
        
        let insets = _style.insets()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: finalLabel, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: finalLabel, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: finalLabel, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: -insets.right),
            NSLayoutConstraint(item: finalLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: finalLabel.font.pointSize * 1.6),
            ]
        )
    }
    
    func configureInitialLabel() {
        guard initialLabel.superview == nil, withIcon else { return }
        self.backgroundView.addSubview(initialLabel)
        
//        let insets = _style.insets()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: initialLabel, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: initialLabel, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: initialLabel, attribute: .trailing, relatedBy: .equal, toItem: backgroundView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: initialLabel, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: backgroundView.bounds.height * smallIconAspect / 2 + 2),
            ]
        )
    }
    
    func configureIcon() {
        guard withIcon else { return }
        
        iconView.removeFromSuperview()
        backgroundView.addSubview(iconView)

        iconView.image = _icon.image()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .centerX, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: iconView, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: smallIconAspect, constant: 0),
            ]
        )
    }
    
    func configureProgress() {
        progressLayerView.image = _style.progressImage()
        
        configureProgressConstraints()
    }
    
    func configureStyle() {
        backgroundView.image = _style.bgImage()
        
        configureProgress()
        
        if _style == .small {
            configureIcon()
        } else if iconLoaded {
            iconView.removeFromSuperview()
        }
    }
    
    private func configureProgressConstraints() {
        progressLayerView.removeConstraints(progressLayerView.constraints)
        progressLayerView.removeFromSuperview()
        backgroundView.insertSubview(progressLayerView, at: 0)
        
        let insets = _style.insets()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: progressLayerView, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: insets.top),
            NSLayoutConstraint(item: progressLayerView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -insets.bottom),
            NSLayoutConstraint(item: progressLayerView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: insets.left),
            ]
        )
        
        progressWidthConstraint = NSLayoutConstraint(item: progressLayerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: progressViewWidth())
        
        if let widthContraint = progressWidthConstraint {
            progressLayerView.addConstraint(widthContraint)
        }
    }
    
    private func initialize() {
        clipsToBounds = false
        backgroundColor = UIColor.clear
        addSubview(backgroundView)
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: backgroundView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        })
        
        configureProgressConstraints()
    }
}
