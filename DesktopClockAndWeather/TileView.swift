//
//  TileView.swift
//  flipClock
//
//  Created by xuwei on 2018/10/20.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Cocoa

class TileView: NSView {
    
    open var digitLabel        = NSTextView()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    enum Position {
        case top
        case bottom
    }
    
    let position: Position
    
    open func setSymbol(_ symbol: String?) {
        digitLabel.string = symbol ?? ""
        
        self.needsLayout = true
    }
    
    fileprivate var font: NSFont?
    
    fileprivate var cornerRadii: CGSize
    
    private var owner : FlapLabel?
    private var isMirror : Bool = false
    
    
    // MARK: - Initializing a Flap View
    required init(builder: FlapLabel, position: Position,isMirror : Bool) {
        self.cornerRadii = CGSize(width: builder.cornerRadius, height: builder.cornerRadius)
        self.position    = position
        self.isMirror = isMirror
        
        super.init(frame: CGRect.zero)
        
        owner = builder
        
        addSubview(digitLabel)
        setupViewsWithBuilder(builder)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        cornerRadii = CGSize(width: 0, height: 0)
        position    = .top
        isMirror = false
        
        super.init(coder: aDecoder)
        
    }
    
    open func mirrorText() {
        var topTransfrom = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi, 1, 0, 0)
        topTransfrom = CATransform3DTranslate(topTransfrom, 0,-bounds.height * 2 , 0)
        self.digitLabel.layer?.transform = topTransfrom
        //        digitLabel.needsLayout = true
        //        digitLabel.needsUpdateConstraints = true
        //        needsLayout = true
        //        needsDisplay = true
    }
    
    open func resetText() {
        self.digitLabel.layer?.transform = CATransform3DIdentity
    }
    
    fileprivate func setupViewsWithBuilder(_ builder: FlapLabel) {
        font = builder.font
        
        self.cornerRadii.width = builder.cornerRadius
        self.cornerRadii.height = builder.cornerRadius
        
        layer?.masksToBounds = true
        backgroundColor     = builder.BackColor
        
        digitLabel.alignment   = builder.textAlignment
        
        digitLabel.textColor       = builder.TextColor
        
        digitLabel.drawsBackground = true
        
        digitLabel.backgroundColor = builder.BackColor
        
        digitLabel.isEditable = false
        digitLabel.isSelectable = false
        
    }
    
    
    // MARK: - Laying out Subviews
    override func layout() {
        super.layout()
        
        setupViewsWithBuilder(owner!)
        
        // Round corners
        let path: NSBezierPath
        
        if position == .top {
            path = NSBezierPath(roundedRect:bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: cornerRadii)
        }
        else {
            path = NSBezierPath(roundedRect:bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: cornerRadii)
        }
        
        let maskLayer  = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer?.mask     = maskLayer
        
        // Position elements
        var digitLabelFrame        = bounds
        
        if position == .top {
            digitLabelFrame.size.height = digitLabelFrame.height * 2
            digitLabelFrame.origin.y    = 0
        }
        else {
            digitLabelFrame.size.height = digitLabelFrame.height * 2
            digitLabelFrame.origin.y    = -digitLabelFrame.height / 2
        }
        
        
        
        
        digitLabel.frame         = digitLabelFrame
        digitLabel.font          = font ?? NSFont(name: "Helvetica Neue", size: bounds.width)
        
        if isMirror {
            self.mirrorText()
        }
    }
}

public struct NSRectCorner: OptionSet {
    public let rawValue: UInt
    
    public static let none = NSRectCorner(rawValue: 0)
    public static let topLeft = NSRectCorner(rawValue: 1 << 0)
    public static let topRight = NSRectCorner(rawValue: 1 << 1)
    public static let bottomLeft = NSRectCorner(rawValue: 1 << 2)
    public static let bottomRight = NSRectCorner(rawValue: 1 << 3)
    public static var all: NSRectCorner {
        return [.topLeft, .topRight, .bottomLeft, .bottomRight]
    }
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public extension NSBezierPath {
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: CGPoint(x: points[0].x, y: points[0].y))
            case .lineTo:
                path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
            case .curveTo:
                path.addCurve(
                    to: CGPoint(x: points[2].x, y: points[2].y),
                    control1: CGPoint(x: points[0].x, y: points[0].y),
                    control2: CGPoint(x: points[1].x, y: points[1].y))
            case .closePath:
                path.closeSubpath()
            }
        }
        return path
    }
    
    public convenience init(roundedRect rect: NSRect, byRoundingCorners corners: NSRectCorner, cornerRadii: NSSize) {
        self.init()
        
        let topLeft = rect.origin
        let topRight = NSPoint(x: rect.maxX, y: rect.minY);
        let bottomRight = NSPoint(x: rect.maxX, y: rect.maxY);
        let bottomLeft = NSPoint(x: rect.minX, y: rect.maxY);
        
        if corners.contains(.topLeft) {
            move(to: CGPoint(
                x: topLeft.x + cornerRadii.width,
                y: topLeft.y))
        } else {
            move(to: topLeft)
        }
        
        if corners.contains(.topRight) {
            line(to: CGPoint(
                x: topRight.x - cornerRadii.width,
                y: topRight.y))
            curve(
                //                to: topRight,
                to: CGPoint(
                    x:topRight.x,
                    y:topRight.y + cornerRadii.height
                ),
                controlPoint1: CGPoint(
                    x: topRight.x,
                    y: topRight.y),
                controlPoint2: CGPoint(
                    x: topRight.x,
                    y: topRight.y))
        } else {
            line(to: topRight)
        }
        
        if corners.contains(.bottomRight) {
            line(to: CGPoint(
                x: bottomRight.x,
                y: bottomRight.y - cornerRadii.height))
            curve(
                to: CGPoint(
                    x: bottomRight.x - cornerRadii.width,
                    y: bottomRight.y),
                controlPoint1: bottomRight,
                controlPoint2: bottomRight)
        } else {
            line(to: bottomRight)
        }
        
        if corners.contains(.bottomLeft) {
            line(to: CGPoint(
                x: bottomLeft.x + cornerRadii.width,
                y: bottomLeft.y))
            curve(
                to: CGPoint(
                    x: bottomLeft.x,
                    y: bottomLeft.y - cornerRadii.height),
                controlPoint1: bottomLeft,
                controlPoint2: bottomLeft)
        } else {
            line(to: bottomLeft)
        }
        
        if corners.contains(.topLeft) {
            line(to: CGPoint(
                x: topLeft.x,
                y: topLeft.y + cornerRadii.height))
            curve(
                to: CGPoint(
                    x: topLeft.x + cornerRadii.width,
                    y: topLeft.y),
                controlPoint1: topLeft,
                controlPoint2: topLeft)
        } else {
            line(to: topLeft)
        }
        
        close()
    }
}

extension NSView {
    
    var backgroundColor: NSColor? {
        
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
            self.needsDisplay = true
            
        }
    }
}





