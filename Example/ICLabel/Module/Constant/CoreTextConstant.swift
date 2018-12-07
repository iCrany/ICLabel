//
//  CoreTextConstant.swift
//  ICLabel_Example
//
//  Created by iCrany on 2018/12/7.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation

class CoreTextConstant: NSObject {
    
    @objc enum ExampleType: Int {
        case undefined
        case paragraph
        case simpleTextFiled
        case columnarLayout
        case manualLineBreak
        case applyParagraphStyle
        case displayTextInNonrectangularRegion
        case ctview //最初版本的 CTView 例子
        case ctview2 // 可滚动的 CTView 例子
        case ctviewV2 // 新版本的学习例子
    }
}
