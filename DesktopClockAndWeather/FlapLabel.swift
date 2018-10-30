//
//  FlapLabel.swift
//  FlapView
//
//  Created by xuwei on 2018/10/21.
//  Copyright © 2018年 xuwei. All rights reserved.
//

import Foundation
import AppKit

protocol FlapLabelPropertyChangedProtocol {
    func updateInfo(_ flapLabel:FlapLabel)
}

@IBDesignable class FlapLabel: NSView,CAAnimationDelegate {
    
    private var topView : TileView?
    private var topBackView : TileView?
    private var bottomView : TileView?
    private var bottomBackView : TileView?
    private var nextView : TileView?
    fileprivate var mainLineView      = NSView()
    
    var delegate:FlapLabelPropertyChangedProtocol?
    
    @IBInspectable open var cornerRadius : CGFloat = 10.0
    
    @IBInspectable var lineHeight : UInt = 4
    
    open var font : NSFont?
    
    @IBInspectable open var BackColor : NSColor = NSColor.darkGray {
        didSet {
            delegate?.updateInfo(self)
        }
    }
    
    @IBInspectable var TextColor : NSColor = NSColor.white {
        didSet {
            delegate?.updateInfo(self)
        }
    }
    
    //    @IBInspectable var LineColor : NSColor = NSColor.black {
    //        didSet {
    //            delegate?.updateInfo(self)
    //        }
    //    }
    
    @IBInspectable var LineColor : NSColor? {
        get {
            return mainLineView.backgroundColor
        }
        set {
            mainLineView.backgroundColor = newValue
        }
    }
    
    @IBInspectable var Text : String = "" {
        didSet {
            setText(Text, animated: false)
        }
    }
    
    @IBInspectable var TextFontFamily : String = "Helvetica Neue" {
        didSet {
            font = NSFont(name: TextFontFamily, size: CGFloat(TextSize))
            delegate?.updateInfo(self)
        }
    }
    @IBInspectable var TextSize : UInt = 100 {
        didSet {
            font = NSFont(name: TextFontFamily, size: CGFloat(TextSize))
            delegate?.updateInfo(self)
        }
    }
    
    
    open var textAlignment : NSTextAlignment = NSTextAlignment.center {
        didSet {
            delegate?.updateInfo(self)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        
        
        super.init(coder: decoder)
        
        font = NSFont(name: TextFontFamily, size: CGFloat(TextSize))
        
        topView = TileView(builder: self, position: TileView.Position.top,isMirror:false)
        topBackView = TileView(builder: self, position: TileView.Position.top,isMirror:false)
        bottomView = TileView(builder: self, position: TileView.Position.bottom,isMirror:false)
        bottomBackView = TileView(builder: self, position: TileView.Position.bottom,isMirror:false)
        nextView = TileView(builder: self, position:    TileView.Position.bottom,isMirror:true)
        
        mainLineView.backgroundColor = NSColor.black
        
        topView?.alphaValue = 0
        bottomView?.alphaValue = 0
        nextView?.alphaValue = 0
        //        nextView?.mirrorText()
        
        bottomBackView?.alphaValue = 1
        topBackView?.alphaValue = 1
        
        addSubview(topBackView!)
        addSubview(bottomBackView!)
        
        addSubview(topView!)
        addSubview(bottomView!)
        addSubview(nextView!)
        addSubview(mainLineView)
        
        topBackView?.layer?.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        topView?.layer?.anchorPoint    = CGPoint(x: 0.5, y: 1.0)
        bottomView?.layer?.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottomBackView?.layer?.anchorPoint = CGPoint(x: 0.5, y: 0)
        nextView?.layer?.anchorPoint = CGPoint(x: 0.5, y: 1)
        //        setupAnimations()
    }
    
    override func layout() {
        
        
        super.layout()
        
        let topLeafFrame    = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
        let bottomLeafFrame = CGRect(x: 0, y: bounds.height / 2, width: bounds.width, height: bounds.height / 2)
        
        let mainLineViewFrame      = CGRect(x: 0, y: bounds.height / 2 - CGFloat(lineHeight) / 2, width: bounds.width, height: CGFloat(lineHeight))
        
        
        topView?.frame    = topLeafFrame
        bottomView?.frame = bottomLeafFrame
        bottomBackView?.frame = bottomLeafFrame
        mainLineView.frame       = mainLineViewFrame
        
        //        print(nextView?.layer?.transform)
        topBackView?.frame = topLeafFrame
        //        print(nextView?.layer?.transform)
        
        if nextView?.position == TileView.Position.bottom {
            nextView?.frame = bottomLeafFrame
        } else {
            nextView?.frame = topLeafFrame
        }
        
    }
    
    
    private var savedText : String = ""
    open func setText(_ text: String?, animated: Bool) -> Void {
        var doAnimated = animated
        if let tmpText = text {
            if tmpText == savedText {
                return;
            }
            if savedText == "" {
                doAnimated = false
            }
            savedText = tmpText
        }
        
        //        savedText = text ?? ""
        
        bottomBackView?.setSymbol(text)
        topBackView?.setSymbol(text)
        nextView?.setSymbol(text)
        
        if doAnimated == true {
            self.rotation()
            
        } else {
            topView?.setSymbol(text)
            bottomView?.setSymbol(text)
            
        }
        
    }
    
    func rotation() {
        
        topView?.alphaValue = 1
        bottomView?.alphaValue = 1
        
        animationTime = .bottom
        nextView?.mirrorText()
        
        rotationFirst(bottomView)
    }
    
    @objc func hideViews() {
        topView?.alphaValue = 0
        bottomView?.alphaValue = 0
        nextView?.alphaValue = 0
        topView?.setSymbol(savedText)
        bottomView?.setSymbol(savedText)
        nextView?.mirrorText()
    }
    
    
    // MARK: - CAAnimation Delegate Methods
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if animationTime == .bottom {
            animationTime = .top
            bottomView?.alphaValue = 0
            nextView?.mirrorText()
            nextView?.alphaValue = 1
            rotationSecond(nextView)
            //            topAnim.beginTime = CACurrentMediaTime()
            //            topView?.layer?.add(topAnim, forKey: "topFlap")
        } else {
            hideViews()
            //            topView?.setSymbol(savedText)
            //            bottomView?.setSymbol(savedText)
        }
    }
    
    
    func rotationFirst(_ view : NSView?) -> Void {
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        
        animation.fromValue = (10/360)*Double.pi
        
        animation.toValue = (180/360)*Double.pi
        
        animation.duration = totalAnimTime / 2
        
        animation.repeatCount = 0
        
        animation.delegate = self
        
        view?.layer?.add(animation, forKey: "rotationSecond")
        
    }
    
    private var isMirrored : Bool = false
    open func testMirror() {
        
        self.nextView?.mirrorText()
        //        if isMirrored {
        //            self.nextView?.layer?.transform = CATransform3DIdentity
        //            isMirrored = false
        //        } else {
        //            let zDepth: CGFloat         = 1000
        //            var skewedIdentityTransform = CATransform3DIdentity
        //            skewedIdentityTransform.m34 = 1 / -zDepth
        //            var transform = skewedIdentityTransform
        ////            transform = CATransform3DTranslate(transform,0,bounds.height / 2,0)
        //            transform = CATransform3DRotate(transform, CGFloat.pi,1,0,0)
        ////            transform = CATransform3DTranslate(transform,0,-bounds.height ,0)
        ////            var topTransfrom = CATransform3DRotate(skewedIdentityTransform, CGFloat.pi, 1, 0, 0)
        ////            topTransfrom = CATransform3DTranslate(topTransfrom, 0,bounds.height , 0)
        ////            nextView?.layer?.transform = topTransfrom
        //            self.nextView?.layer?.transform = transform
        //            isMirrored = true
        //
        //        }
        
    }
    
    func rotationSecond(_ view : NSView?) -> Void {
        let animation = CABasicAnimation(keyPath: "transform")
        
        let zDepth: CGFloat         = 1000
        var skewedIdentityTransform = CATransform3DIdentity
        skewedIdentityTransform.m34 = 1 / -zDepth
        
        
        //         let topTransfrom = skewedIdentityTransform
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DRotate(skewedIdentityTransform, (180 / 360) * CGFloat.pi , 1, 0, 0))
        animation.toValue = NSValue(caTransform3D: CATransform3DRotate(skewedIdentityTransform, (355 / 360) * CGFloat.pi , 1, 0, 0))
        
        //        animation.fromValue = (10/360) * Double.pi
        
        //        animation.toValue = (355/360) * Double.pi
        
        animation.duration = totalAnimTime / 2
        
        animation.repeatCount = 0
        
        animation.delegate = self
        
        view?.layer?.add(animation, forKey: "rotationFirst")
    }
    
    private var totalAnimTime : Double = 1.0
    
    /// Defines the current time of the animation to know which tile to display.
    fileprivate enum AnimationTime {
        /// Tic time.
        case top
        /// Tac time.
        case bottom
    }
    
    fileprivate var animationTime = AnimationTime.bottom
    //    fileprivate let topAnim       = CABasicAnimation(keyPath: "transform")
    //    fileprivate let bottomAnim    = CABasicAnimation(keyPath: "transform")
    //
    //    fileprivate func setupAnimations() {
    //        // Set the perspective
    //        let zDepth: CGFloat         = 1000
    //        var skewedIdentityTransform = CATransform3DIdentity
    //        skewedIdentityTransform.m34 = 1 / -zDepth
    //
    //        // Predefine the animation
    //
    //        let topTransfrom = CATransform3DTranslate(skewedIdentityTransform,0,bounds.height / 2 ,0)
    //
    //        topAnim.fromValue = NSValue(caTransform3D: CATransform3DRotate(topTransfrom, (90 / 180) * CGFloat.pi , 1, 0, 0))
    //        topAnim.toValue   = NSValue(caTransform3D: CATransform3DRotate(topTransfrom, (180 / 180) * CGFloat.pi , 1, 0, 0))
    //        topAnim.isRemovedOnCompletion = true
    //        topAnim.fillMode              = CAMediaTimingFillMode.both
    //        topAnim.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
    //        topAnim.duration = self.totalAnimTime * 2 / 4
    //        topAnim.delegate = self
    //
    //        bottomAnim.fromValue = NSValue(caTransform3D: skewedIdentityTransform)
    //        bottomAnim.toValue   = NSValue(caTransform3D: CATransform3DRotate(skewedIdentityTransform, CGFloat.pi / 2, 1, 0, 0))
    //        bottomAnim.delegate              = self
    //        bottomAnim.isRemovedOnCompletion = true
    //        bottomAnim.fillMode              = CAMediaTimingFillMode.both
    //        bottomAnim.timingFunction        = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    //        bottomAnim.duration = self.totalAnimTime * 3  / 4
    //
    //    }
    
}

