//
//  ColourfulProgressView.swift
//  Calamity
//
//  Created by Pavel Stoma on 3/18/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import UIKit

enum ColourfulProgressViewType : Int {
    case first = 33
    case second = 66
    case third = 100
}

@IBDesignable
class ColourfulProgressView: UIView {
    private let ColourfulProgressViewTopMargin: Int = 5
    private let ColourfulProgressViewNumberOfSegments: Int = 3
    
    @IBInspectable var initialFillColor: UIColor?
    @IBInspectable var oneThirdFillColor: UIColor?
    @IBInspectable var twoThirdsFillColor: UIColor?
    @IBInspectable var finalFillColor: UIColor?
    @IBInspectable var containerColor: UIColor?
    @IBInspectable var labelTextColor: UIColor?
    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderLineWidth: Int = 0
    @IBInspectable var currentValue: Int = 0
    @IBInspectable var maximumValue: Int = 0
    @IBInspectable var showLabels: Bool = false
    
    private lazy var backgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: backgroundViewHeight()))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = containerColor
        return view
    }()
    
    private lazy var fillingView: UIView = {
        let view = UIView(frame: CGRect(x: CGFloat(self.borderLineWidth), y: CGFloat(self.borderLineWidth), width: fillingViewWidth(), height: fillingViewHeight()))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = fillingColor()
        return view
    }()
    
    private lazy var initialLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = self.labelTextColor
        
        if let font = R.font.lasco(size: 12) {
            label.font = font
        }
        
        label.textAlignment = .left
        return label
    }()
    
    private lazy var finalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(format: "%li", maximumValue)
        label.textColor = labelTextColor
        
        if let font = R.font.lasco(size: 12) {
            label.font = font
        }
        
        label.textAlignment = .right
        return label
    }()
    
    private var fillingWidthConstraint: NSLayoutConstraint? = nil
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - IB Live Rendering Preparation
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    // MARK: - Setup Methods
    func setupView() {
        setupBackgroundView()
        setupFillingView()
        setupInitialLabel()
        setupFinalLabel()
    }
    
    func setupBackgroundView() {
        addSubview(backgroundView)
        
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
        
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: backgroundView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0)
        })
        
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius + 1.0
    }
    
    func setupFillingView() {
        backgroundView.addSubview(fillingView)
        
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-bPadding-[fillingView(fvHeight)]->=bPadding-|", options: [], metrics: viewMetrics(), views: viewsDictionary())
        
        backgroundView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-bPadding-[fillingView]->=bPadding-|", options: [], metrics: viewMetrics(), views: viewsDictionary())
            
        backgroundView.addConstraints(constraints)
        
        fillingWidthConstraint = NSLayoutConstraint(item: fillingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fillingViewWidth())
        
        if let fillingWidthConstraint = fillingWidthConstraint {
            fillingView.addConstraint(fillingWidthConstraint)
        }
        
        
        fillingView.layer.cornerRadius = (fillingViewWidth() > cornerRadius) ? cornerRadius : 0
        fillingView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius + 1.0
    }
    
    func setupInitialLabel() {
        if !showLabels {
            return
        }
    
        addSubview(initialLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]-mPadding-[initialLabel]|", options: [], metrics: viewMetrics(), views: viewsDictionary()))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[initialLabel]->=0-|", options: [], metrics: nil, views: viewsDictionary()))
    }
    
    func setupFinalLabel() {
        if !showLabels {
            return
        }
        
        addSubview(finalLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]-mPadding-[finalLabel]|", options: [], metrics: viewMetrics(), views: viewsDictionary()))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[initialLabel]->=0-[finalLabel]-0-|", options: [], metrics: nil, views: viewsDictionary()))
    }
    
    // MARK: - Update Filling View
    func update(toCurrentValue currentValue: Int, animated: Bool) {
        self.currentValue = currentValue
        
        let borders = CGFloat(2 * borderLineWidth)
        let width = ceil((backgroundView.bounds.size.width - borders) * fractionLeft())
        
        fillingWidthConstraint?.constant = width
        
        if animated {
            UIView.animate(withDuration: 0.4, animations: {
                self.fillingView.layoutIfNeeded()
                self.fillingView.backgroundColor = self.fillingColor()
            })
        } else {
            fillingView.backgroundColor = fillingColor()
        }
    }
    
    // MARK: - Private Helpers
    func fillingColor() -> UIColor? {
        let segmentType: ColourfulProgressViewType = segmentTypeForCurrentValue()
        let initialSegmentColor: UIColor? = self.initialSegmentColor(forSegmentType: segmentType)
        let finalSegmentColor: UIColor? = self.finalSegmentColor(forSegmentType: segmentType)
        var initialRed: CGFloat = 0
        var initialGreen: CGFloat = 0
        var initialBlue: CGFloat = 0
        var finalRed: CGFloat = 0
        var finalGreen: CGFloat = 0
        var finalBlue: CGFloat = 0
        let segmentFractionLeft: CGFloat = self.segmentFractionLeft()
        
        initialSegmentColor?.getRed(&initialRed, green: &initialGreen, blue: &initialBlue, alpha: nil)
        finalSegmentColor?.getRed(&finalRed, green: &finalGreen, blue: &finalBlue, alpha: nil)
        
        finalRed = initialRed - (initialRed - finalRed) * CGFloat(segmentFractionLeft)
        finalGreen = initialGreen - (initialGreen - finalGreen) * CGFloat(segmentFractionLeft)
        finalBlue = initialBlue - (initialBlue - finalBlue) * CGFloat(segmentFractionLeft)
        
        return UIColor(red: finalRed, green: finalGreen, blue: finalBlue, alpha: 0.8)
    }
    
    func segmentTypeForCurrentValue() -> ColourfulProgressViewType {
        let currentPercentage: CGFloat = fractionLeft() * 100
        let segmentFloatSize = CGFloat(maximumValue) / CGFloat(ColourfulProgressViewNumberOfSegments)
        let segmentIntegerSize: Int = maximumValue / ColourfulProgressViewNumberOfSegments
        let remainder: CGFloat = segmentFloatSize - CGFloat(segmentIntegerSize)
        
        if currentPercentage < (CGFloat(ColourfulProgressViewType.first.rawValue) + remainder) {
            return ColourfulProgressViewType.first
        }
        
        if currentPercentage < (CGFloat(ColourfulProgressViewType.second.rawValue) + 2 * remainder) {
            return ColourfulProgressViewType.second
        }
        
        return ColourfulProgressViewType.third
    }
    
    func fractionLeft() -> CGFloat {
        var maximumValue = self.maximumValue
        maximumValue = (maximumValue > 0) ? maximumValue : 1
        
        if currentValue <= 0 {
            return 1
        }
        
        if currentValue > (maximumValue + 1) {
            return 0
        }
        
        return CGFloat(maximumValue - currentValue + 1) / CGFloat(maximumValue)
    }
    
    func segmentFractionLeft() -> CGFloat {
        var maximumValue = CGFloat(self.maximumValue) / CGFloat(ColourfulProgressViewNumberOfSegments)
        maximumValue = (maximumValue > 0) ? maximumValue : 1
        
        var segmentValue: CGFloat = CGFloat(currentValue - 1)
        while segmentValue > maximumValue {
            segmentValue = segmentValue - maximumValue
        }
        return (maximumValue - segmentValue) / maximumValue
    }

    // MARK: - Auto Layout Helpers
    func viewsDictionary() -> [String : Any] {
        let viewsDictionary = [
            "backgroundView" : backgroundView,
            "fillingView" : fillingView,
            "initialLabel" : initialLabel,
            "finalLabel" : finalLabel
        ]
        
        var viewsMutableDictionary: [String : Any] = [:]
        
        viewsDictionary.forEach { (key, obj) in
            viewsMutableDictionary[key.replacingOccurrences(of: "self.", with: "")] = obj
        }
        
        return viewsMutableDictionary
    }
    
    func viewMetrics() -> [String : Any]? {
        return [
            "bPadding": NSNumber(value: borderLineWidth),
            "mPadding": NSNumber(value: ColourfulProgressViewTopMargin),
            "fvHeight": NSNumber(value: Float(fillingViewHeight()))
        ]
    }
    
    func backgroundViewHeight() -> CGFloat {
        return ceil((showLabels ? 0.65 : 1.0) * bounds.size.height)
    }
    
    func fillingViewHeight() -> CGFloat {
        return backgroundView.bounds.size.height - CGFloat(2 * borderLineWidth)
    }
    
    func fillingViewWidth() -> CGFloat {
        return ceil((backgroundView.bounds.size.width - CGFloat(2 * borderLineWidth)) * fractionLeft())
    }
    
    // MARK: - Color choosing
    func finalSegmentColor(forSegmentType segmentType: ColourfulProgressViewType) -> UIColor? {
        switch segmentType {
        case .first:
            return initialSegmentColor(forSegmentType: .first)
        case .second:
            return initialSegmentColor(forSegmentType: .second)
        case .third:
            return finalFillColor
        }
    }
    
    func initialSegmentColor(forSegmentType segmentType: ColourfulProgressViewType) -> UIColor? {
        switch segmentType {
        case .first:
            return initialFillColor
        case .second:
            return oneThirdFillColor
        case .third:
            return twoThirdsFillColor
        }
    }
}
