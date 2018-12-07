//
//  LayingOutParagraphView.swift
//  iOSExample
//
//  Created by iCrany on 2017/10/30.
//  Copyright © 2017 iCrany. All rights reserved.
//

import Foundation
import UIKit
import CoreText

class LayingOutParagraphView: UIView {

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        NSLog("This is LayingOutParagraphView drawRect method, bounds: \(self.bounds)")
        super.draw(rect)

        // Initialize a graphics context in iOS.
        let currentContext: CGContext? = UIGraphicsGetCurrentContext()

        guard let context = currentContext else {
            NSLog("[Error] \(NSStringFromClass(LayingOutParagraphView.self)) currentContext is nil")
            return
        }

        // Flip the context coordinates, in iOS only.
        //TODO: 这里的这个矩阵变换的逻辑还是没有搞清楚
        NSLog("[0] CGContext: a: \(context.ctm.a) b: \(context.ctm.b) c: \(context.ctm.c) d: \(context.ctm.d) tx: \(context.ctm.tx) ty: \(context.ctm.ty)")
        context.translateBy(x: 0, y: self.bounds.height)
        NSLog("[1] CGContext: a: \(context.ctm.a) b: \(context.ctm.b) c: \(context.ctm.c) d: \(context.ctm.d) tx: \(context.ctm.tx) ty: \(context.ctm.ty)")
        context.scaleBy(x: 1.0, y: -1.0)
        NSLog("[2] CGContext: a: \(context.ctm.a) b: \(context.ctm.b) c: \(context.ctm.c) d: \(context.ctm.d) tx: \(context.ctm.tx) ty: \(context.ctm.ty)")

        // Set the text matrix.
        NSLog("[0] CGContext.textMatrix: \(context.textMatrix)")
        context.textMatrix = CGAffineTransform.identity
        NSLog("[1] CGContext.textMatrix: \(context.textMatrix)")

        // Create a path which bounds the area where you will be drawing text. The path need not be rectangular
        let path: CGMutablePath = CGMutablePath.init()

        // In this simple example, initialize a rectangular path.
        let bounds: CGRect = CGRect.init(x: 20.0, y: 0.0, width: 200.0, height: self.bounds.size.height - 20.0)
        path.addRect(bounds)

        // Initialize a string.
        let textString: CFString = "Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine." as CFString

        // Create a mutable attributed string with a max length of 0.
        // The max length is a hint as to how much internal storage to reserve.
        // 0 means no hint.
        let attrString: CFMutableAttributedString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)

        // Copy the textString into the newly created attrString
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString)

        // Create a color that will be added as an attribute to the attrString.
        let rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [1.0, 0.0, 0.0, 0.8]
        let red: CGColor? = CGColor.init(colorSpace: rgbColorSpace, components: components)

        // Set the color of the first 12 chars to red.
        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), NSAttributedString.Key.foregroundColor as CFString, red)

        // Create the framesetter with the attributed string.
        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrString)

        //Create a frame
        let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        // Draw the specified frame in the given context.
        CTFrameDraw(frame, context)
    }
}
