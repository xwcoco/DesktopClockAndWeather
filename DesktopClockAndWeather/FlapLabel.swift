//
//  FlipClockView.swift
//  DesktopClockAndWeather
//
//  Created by 徐卫 on 2018/10/29.
//  Copyright © 2018 xuwei. All rights reserved.
//

import Foundation
import AppKit


enum kFlipAnimationState: Int {
    case kFlipAnimationNormal, kFlipAnimationTopDown, kFlipAnimationBottomDown
}

class FlipView: NSView {
    var digitLable: NSTextView
    var lineView: NSView
    
    override init(frame frameRect: NSRect) {
        digitLable = NSTextView()
        lineView = NSView()
        super.init(frame: frameRect)
        self.initProps()
    }
    
    
    var fontSize: Int = 80 {
        didSet {
            self.updateFontSize()
        }
    }
    
    
    func updateFontSize() {
        digitLable.font = NSFont.init(name: "Helvetica Neue", size: CGFloat(self.fontSize))
        //        self.digitLable.sizeToFit()
        //        self.digitLable.needsDisplay = true
    }
    
    
    
    func initProps() -> Void {
        self.backgroundColor = NSColor.darkGray
        self.layer?.cornerRadius = 10
        self.layer?.masksToBounds = true
        
        self.updateFontSize()
        //        digitLable.font = NSFont.init(name: "Helvetica Neue", size: 100)
        self.digitLable.string = "0"
        self.digitLable.isSelectable = false
        self.digitLable.isEditable = false
        digitLable.alignment = .center
        digitLable.textColor = NSColor.white
        digitLable.backgroundColor = NSColor.clear
        //        digitLable.sizeToFit()
        
        self.addSubview(digitLable)
        
        lineView.backgroundColor = NSColor.black
        self.addSubview(lineView)
    }
    
    required init?(coder decoder: NSCoder) {
        digitLable = NSTextView()
        lineView = NSView()
        super.init(coder: decoder)
        self.initProps()
    }
    
    private var lineHeight: CGFloat = 4
    
    
    override func layout() {
        super.layout()
        //        let dlSize = self.digitLable.bounds
        //        if (dlSize.width == 0 || dlSize.height == 0) {
        self.digitLable.frame = self.bounds
        //        } else {
        //            let rect = NSRect.init(x: (self.bounds.width - dlSize.width) / 2 , y: (self.bounds.height - dlSize.height) / 2, width: dlSize.width, height: dlSize.height)
        //            self.digitLable.frame = rect
        //
        //        }
        lineView.frame = NSRect.init(x: 0, y: (bounds.height - lineHeight) / 2, width: bounds.width, height: lineHeight)
    }
    
    var Text: String = "" {
        didSet {
            self.digitLable.string = Text
        }
    }
    
}

@IBDesignable
class FlipLabel: NSView, CAAnimationDelegate {
    var animationState: kFlipAnimationState
    
    var currentView: FlipView
    var nextView: FlipView?
    
    @IBInspectable var Text: String = "" {
        didSet {
            setText(Text, animated: false)
        }
    }
    
    @IBInspectable var FontSize: Int = 80 {
        didSet {
            //            self.needsDisplay = true
            self.setText(self.Text, animated: false)
            
        }
    }
    
    var backColor: NSColor = NSColor.darkGray {
        didSet {
            self.backgroundColor = backColor
            
        }
    }
    
    required init?(coder decoder: NSCoder) {
        currentView = FlipView()
        animationState = .kFlipAnimationNormal
        super.init(coder: decoder)
        
        currentView.fontSize = self.FontSize
        
        self.backgroundColor = self.backColor
        self.layer?.cornerRadius = 10
        self.addSubview(currentView)
    }
    
    override init(frame frameRect: NSRect) {
        currentView = FlipView()
        animationState = .kFlipAnimationNormal
        super.init(frame: frameRect)
        
        currentView.fontSize = self.FontSize
        self.backgroundColor = self.backColor
        self.layer?.cornerRadius = 10
        self.addSubview(currentView)
        
    }
    
    override func layout() {
        super.layout()
        
        currentView.frame = self.bounds
        currentView.layout()
        
    }
    
    
    func setText(_ newText: String, animated: Bool = true) -> Void {
        
        if (newText == self.currentView.Text) {
            return
        }
        
        if !animated {
            self.currentView.Text = newText
            if (self.currentView.fontSize != self.FontSize) {
                self.currentView.fontSize = self.FontSize
            }
            return
        }
        
        if (self.currentView.bounds.width == 0 || self.currentView.bounds.height == 0) {
            self.currentView.Text = newText
            return
        }
        
        self.nextView = FlipView.init(frame: self.bounds)
        self.nextView?.Text = newText
        self.nextView?.fontSize = self.FontSize
        //        self.nextView?.backgroundColor = NSColor.red
        
        self.changeAnimationState()
    }
    
    
    func snapshotsForView(_ view: NSView) -> NSArray {
        let bitmapRep = bitmapImageRepForCachingDisplay(in: view.bounds)
        bitmapRep?.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRep!)

        let image = NSImage.init(size: view.bounds.size)
        image.addRepresentation(bitmapRep!)
        
//        if let image = view.image {
        
        
        
        
        let topImage = NSImage.init(size: NSSize.init(width: view.bounds.width, height: view.bounds.height / 2))
        
        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil, pixelsWide: Int(view.bounds.width), pixelsHigh: Int(view.bounds.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)
        topImage.addRepresentation(rep!)
        
        topImage.lockFocus()
        
        
        image.draw(at: NSPoint.init(x: 0, y: 0), from: NSRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2), operation: NSCompositingOperation.copy, fraction: 1)
        
        topImage.unlockFocus()
        
        let botImage = NSImage.init(size: NSSize.init(width: view.bounds.width, height: view.bounds.height / 2))
        
        botImage.lockFocus()
        
        image.draw(at: NSPoint.init(x: 0, y: 0), from: NSRect.init(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2), operation: NSCompositingOperation.copy, fraction: 1)
        
        botImage.unlockFocus()
        
        let topImageView = NSImageView.init(image: topImage)
        
        topImageView.frame = NSRect.init(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height / 2)
        topImageView.wantsLayer = true
        //        topImageView.frame = NSRect.init(x: 0, y: 0, width: bounds.height, height: bounds.height )
        
        let botImageView = NSImageView.init(image: botImage)
        botImageView.wantsLayer = true
        //        botImageView.frame = NSRect.init(x: bounds.minX, y: -bounds.minY, width: bounds.width, height: bounds.height / 2)
        
        return [topImageView, botImageView]
            
//        }
//        else {
//            return [NSImageView(),NSImageView()]
//        }
    }
    
    private var topHalfFrontView: NSView?
    private var bottomHalfFrontView: NSView?
    
    private var topHalfBackView: NSView?
    private var bottomHalfBackView: NSView?
    
    
    func snapshotForMirrorView(_ view: NSView) -> NSView {
        let bitmapRep = bitmapImageRepForCachingDisplay(in: view.bounds)
        bitmapRep?.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRep!)
        
        let image = NSImage.init(size: view.bounds.size)
        image.addRepresentation(bitmapRep!)
        
        
        let botImage = image.mirror()
        botImage.lockFocus()
        
        image.draw(at: NSPoint.init(x: 0, y: 0), from: NSRect.init(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height), operation: NSCompositingOperation.copy, fraction: 1)
        
        botImage.unlockFocus()
        
        let imageView = NSImageView.init(image: botImage)
        imageView.wantsLayer = true
        
        return imageView
    }
    
    func animateViewDown() {
        let list = self.snapshotsForView(self.currentView)
        topHalfFrontView = list.firstObject as? NSView
        bottomHalfFrontView = list.lastObject as? NSView
        
        if (topHalfFrontView == nil || bottomHalfFrontView == nil) {
            return
        }
        
        //        topHalfFrontView?.frame = topHalfFrontView!.frame.offsetBy(dx: self.frame.origin.x, dy: self.frame.origin.y)
        self.addSubview(topHalfFrontView!)
        
        bottomHalfFrontView?.frame = topHalfFrontView!.frame
        bottomHalfFrontView?.frame = bottomHalfFrontView!.frame.offsetBy(dx: 0, dy: topHalfFrontView!.frame.size.height)
        
        self.addSubview(bottomHalfFrontView!)
        
        self.currentView.removeFromSuperview()
        
        if (self.nextView == nil) {
            return
        }
        
        let backviews = self.snapshotsForView(self.nextView!)
        //        self.topHalfBackView = backviews.firstObject as? NSView
        self.bottomHalfBackView = backviews.lastObject as? NSView
        
        let tmpView = backviews.firstObject as? NSView
        tmpView?.frame = bottomHalfFrontView!.frame
        self.topHalfBackView = snapshotForMirrorView(tmpView!)
        
        
        topHalfBackView?.frame = bottomHalfFrontView!.frame
        bottomHalfBackView?.frame = bottomHalfFrontView!.frame
        
        
        
        self.addSubview(topHalfBackView!, positioned: NSWindow.OrderingMode.below, relativeTo: topHalfFrontView)
        self.addSubview(bottomHalfBackView!, positioned: NSWindow.OrderingMode.below, relativeTo: bottomHalfFrontView)
        
        var skewedIdentityTransform = CATransform3DIdentity
        skewedIdentityTransform.m34 = 1 / -950
        
        
        let topAnim = CABasicAnimation.init(keyPath: "transform")
        topAnim.beginTime = CACurrentMediaTime()
        topAnim.duration = 0.6
        topAnim.fromValue = CATransform3DRotate(skewedIdentityTransform, 10 / 360 * CGFloat.pi, 1, 0, 0)
        topAnim.toValue = CATransform3DRotate(skewedIdentityTransform, 180 / 360 * CGFloat.pi, 1, 0, 0)
        topAnim.delegate = self
        topAnim.isRemovedOnCompletion = false
        topAnim.fillMode = .forwards
        topAnim.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
        
        bottomHalfFrontView?.layer?.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        bottomHalfFrontView?.layer?.add(topAnim, forKey: "topDownFlip")
        
        let bottomAnim = CABasicAnimation.init(keyPath: "transform")
        bottomAnim.beginTime = topAnim.beginTime + topAnim.duration
        bottomAnim.duration = topAnim.duration / 4
        bottomAnim.fromValue = CATransform3DRotate(skewedIdentityTransform, CGFloat.pi / 2, 1, 0, 0)
        bottomAnim.toValue = CATransform3DRotate(skewedIdentityTransform, CGFloat.pi, 1, 0, 0)
        bottomAnim.delegate = self
        bottomAnim.isRemovedOnCompletion = false
        bottomAnim.fillMode = .both
        bottomAnim.timingFunction = CAMediaTimingFunction.init(name: .linear)
        topHalfBackView?.layer?.add(bottomAnim, forKey: "TopDownFlip")
    }
    
    func movedFromAnchorPoint(oldCenter: CGPoint, oldAnchorPoint: CGPoint, newAnchorPoint: CGPoint, withFrame: CGRect) -> CGPoint {
        let anchorPointDiff = CGPoint.init(x: -newAnchorPoint.x + oldAnchorPoint.x, y: -newAnchorPoint.y + oldAnchorPoint.y)
        let newCenter = CGPoint.init(x: oldCenter.x - (anchorPointDiff.x * withFrame.size.width), y: oldCenter.y - anchorPointDiff.y * withFrame.size.height)
        return newCenter
    }
    
    func changeAnimationState() {
        switch self.animationState {
        case .kFlipAnimationNormal:
            self.animateViewDown()
            animationState = .kFlipAnimationTopDown
            break
        case .kFlipAnimationTopDown:
            self.topHalfBackView?.removeFromSuperview()
            if (self.topHalfBackView != nil) {
                self.addSubview(self.topHalfBackView!)
            }
            self.animationState = .kFlipAnimationBottomDown
            break
        default:
            self.currentView = self.nextView!
            self.addSubview(self.currentView)
            self.nextView = nil
            topHalfFrontView?.removeFromSuperview()
            bottomHalfFrontView?.removeFromSuperview()
            topHalfBackView?.removeFromSuperview()
            bottomHalfBackView?.removeFromSuperview()
            
            topHalfFrontView = nil
            bottomHalfFrontView = nil
            topHalfBackView = nil
            bottomHalfBackView = nil
            self.animationState = .kFlipAnimationNormal
            break
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.changeAnimationState()
    }
}


@IBDesignable
class MultiFlipLabel: NSView {
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private var flipLabelList: [NSView] = []
    
    @IBInspectable var Text: String = "" {
        didSet {
            self.setText(Text, animated: false)
        }
    }
    
    @IBInspectable var FontSize: Int = 80 {
        didSet {
            
        }
    }
    
    @IBInspectable var BackColor: NSColor = NSColor.darkGray {
        didSet {
            
        }
    }
    
    func stringToList(str: String) -> [String] {
        var ret: [String] = []
        for char in str {
            let cStr = String(char)
            ret.append(cStr)
        }
        return ret
    }
    
    func isDigit(_ char: String) -> Bool {
        if (char >= "0" && char <= "9") {
            return true
        }
        return false
    }
    
    func createTextView(_ str: String) -> NSView {
        let view = NSTextView()
        view.string = str
        view.backgroundColor = NSColor.clear
        view.font = NSFont.init(name: "Helvetica Neue", size: CGFloat(self.FontSize))
        view.isEditable = false
        view.isSelectable = false
        view.sizeToFit()
        view.layoutManager?.ensureLayout(for: view.textContainer!)
        if let rect = view.layoutManager?.usedRect(for: view.textContainer!) {
            if (rect.width > self.nonDigitSpace) {
                self.nonDigitSpace = rect.width
            }
        }
        //        print(rect)
        
        //        view.frame = NSRect.init(x: 0, y: 0, width: 20, height: self.bounds.height)
        return view
    }
    
    private var nonDigitNum: Int = 0
    
    func setText(_ newText: String, animated: Bool = true) -> Void {
        let list = self.stringToList(str: newText)
        
        if (self.flipLabelList.count == 0) {
            self.nonDigitNum = 0
            for str in list {
                
                if (isDigit(str)) {
                    let flip = FlipLabel()
                    flip.Text = str
                    self.flipLabelList.append(flip)
                    self.addSubview(flip)
                } else {
                    let view = self.createTextView(str)
                    self.nonDigitNum = self.nonDigitNum + 1
                    self.flipLabelList.append(view)
                    self.addSubview(view)
                }
                
            }
            self.layout()
        } else if self.flipLabelList.count != list.count {
            return
        } else {
            for i in 0..<list.count {
                let str = list[i]
                let view = flipLabelList[i]
                if self.isDigit(str) {
                    if let flip = view as? FlipLabel {
                        flip.setText(str, animated: animated)
                    }
                }
            }
        }
    }
    
    private var space: CGFloat = 10
    private var nonDigitSpace: CGFloat = 24
    
    //    func checkNonDigitWidth() -> Void {
    //        for view in self.flipLabelList {
    //            if view is NSTextView {
    //
    //                (view as! NSTextView).sizeToFit()
    //                let size = view.sizeThatFits
    //                if (self.nonDigitSpace < size.width) {
    //                    self.nonDigitSpace = size.width
    //                }
    //            }
    //        }
    //    }
    
    override func layout() {
        super.layout()
        
        if (flipLabelList.count == 0) {
            return
        }
        
        if (self.nonDigitNum == flipLabelList.count) {
            return
        }
        
        //        self.checkNonDigitWidth()
        
        let tmpw: CGFloat = self.bounds.width - CGFloat(flipLabelList.count - 1) * space - CGFloat(self.nonDigitNum) * nonDigitSpace
        
        let w: CGFloat = tmpw / CGFloat(flipLabelList.count - self.nonDigitNum)
        
        var left: CGFloat = 0
        
        for view in self.flipLabelList {
            var rect: NSRect
            if view is FlipLabel {
                rect = NSRect.init(x: left, y: 0, width: w, height: self.bounds.height)
                left = left + w + self.space
            } else {
                rect = NSRect.init(x: left, y: 0, width: self.nonDigitSpace, height: self.bounds.height)
                left = left + self.nonDigitSpace + space
            }
            view.frame = rect
        }
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
    
    var center: CGPoint {
        get {
            return CGPoint.init(x: self.frame.origin.x + self.frame.width / 2, y: frame.origin.y + frame.height / 2)
        }
        
        set {
            self.frame.origin.x = newValue.x - self.frame.width / 2
            self.frame.origin.y = newValue.y - self.frame.height / 2
        }
    }
    
    func setAnchorPoint (anchorPoint: CGPoint)
    {
        if let layer = self.layer
        {
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
            
            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())
            
            var position = layer.position
            
            position.x -= oldPoint.x
            position.x += newPoint.x
            
            position.y -= oldPoint.y
            position.y += newPoint.y
            
            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
    
    var image: NSImage? {
        return NSImage(data: dataWithPDF(inside: bounds))
    }
    
}

public extension NSImage {
    public func imageRotatedByDegreess(degrees: CGFloat) -> NSImage {
        
        var imageBounds = NSZeroRect ; imageBounds.size = self.size
        let pathBounds = NSBezierPath(rect: imageBounds)
        var transform = NSAffineTransform()
        transform.rotate(byDegrees: degrees)
        pathBounds.transform(using: transform as AffineTransform)
        let rotatedBounds: NSRect = NSMakeRect(NSZeroPoint.x, NSZeroPoint.y, self.size.width, self.size.height)
        let rotatedImage = NSImage(size: rotatedBounds.size)
        
        //Center the image within the rotated bounds
        imageBounds.origin.x = NSMidX(rotatedBounds) - (NSWidth(imageBounds) / 2)
        imageBounds.origin.y = NSMidY(rotatedBounds) - (NSHeight(imageBounds) / 2)
        
        // Start a new transform
        transform = NSAffineTransform()
        // Move coordinate system to the center (since we want to rotate around the center)
        transform.translateX(by: +(NSWidth(rotatedBounds) / 2), yBy: +(NSHeight(rotatedBounds) / 2))
        transform.rotate(byDegrees: degrees)
        // Move the coordinate system bak to normal
        transform.translateX(by: -(NSWidth(rotatedBounds) / 2), yBy: -(NSHeight(rotatedBounds) / 2))
        // Draw the original image, rotated, into the new image
        rotatedImage.lockFocus()
        transform.concat()
        self.draw(in: imageBounds, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1)
        //        self.drawInRect(imageBounds, fromRect: NSZeroRect, operation: NSCompositingOperation.CompositeCopy, fraction: 1.0)
        rotatedImage.unlockFocus()
        
        return rotatedImage
    }
    
    public func mirror() -> NSImage {
        let image = NSImage(size: self.size)
        let transform = NSAffineTransform()
        transform.translateX(by: 0, yBy: self.size.height)
        transform.scaleX(by: 1, yBy: -1)
        image.lockFocus()
        transform.concat()
        self.draw(in: NSRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        image.unlockFocus()
        return image
        
    }
    
}

