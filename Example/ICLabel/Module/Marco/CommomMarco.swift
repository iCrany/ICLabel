//
//  CommomMarco.swift
//  ICLabel_Example
//
//  Created by iCrany on 2018/12/7.
//  Copyright © 2018 crany1992@gmail.com. All rights reserved.
//

import Foundation

public let kIsIphoneX: Bool = (kScreenWidth == 375 && kScreenHeight == 812) ? true : false

public let kScreenWidth: CGFloat  = UIScreen.main.bounds.size.width
public let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

// 顶部和底部的偏移量
public let kTopOffSet: CGFloat    = kIsIphoneX ? 24 : 0
public let kBottomOffset: CGFloat = kIsIphoneX ? 34 : 0

// StatusBar高度 (非iPhoneX == 20，iPhoneX == 44)
public let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
