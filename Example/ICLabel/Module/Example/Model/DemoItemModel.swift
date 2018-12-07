//
//  DemoItemModel.swift
//  ICLabel_Example
//
//  Created by iCrany on 2018/12/7.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation

class DemoItemModel: NSObject {
    @objc var title: String
    @objc var className: String
    
    @objc init(title: String, className: String) {
        self.title = title
        self.className = className
        super.init()
    }
}
