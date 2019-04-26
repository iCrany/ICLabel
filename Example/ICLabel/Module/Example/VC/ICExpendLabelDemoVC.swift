//
//  ICExpendLabelDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/8.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel
import M80AttributedLabel
import SnapKit
import YYText

//swiftlint:disable force_cast
class ICExpendLabelDemoVC: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.white

        let testAttrStr = NSMutableAttributedString(string: "哈中test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀速度快回复肯定会开发可来得及分类的空间烂大街法律框架爱离开对方就流口水的了肯定是解放路口就冻死了卡减肥了空间了空间大浪费空间了空间撒蝶恋蜂狂氪金大佬开房记录卡机了看见对方立刻据了解")

        let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
        let maxSize: CGSize = CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude)

        let linkStr: String = "\(kEllipsisCharacter)全文"
        let seeMore: NSMutableAttributedString = NSMutableAttributedString(string: linkStr)

        let expendLabel: ICLabel = ICLabel()
        expendLabel.isUserInteractionEnabled = true
        expendLabel.attributedText = seeMore
        expendLabel.backgroundColor = UIColor.clear
        let expendLabelSize: CGSize = expendLabel.sizeThatFits(maxSize)
        expendLabel.frame = CGRect(origin: .zero, size: expendLabelSize)
        let truncationToken: NSMutableAttributedString = NSMutableAttributedString()
        
        let canClickLabel = ICLabel()
        canClickLabel.isUserInteractionEnabled = true
        canClickLabel.truncationToken = truncationToken
        canClickLabel.backgroundColor = UIColor.lightGray
        canClickLabel.edgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        canClickLabel.numberOfLines = 4
        canClickLabel.attributedText = testAttrStr
//        canClickLabel.backgroundColor = UIColor.red
        let canClickLabelSize = canClickLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right,
                                                                  height:  kScreenHeight))
        self.view.addSubview(canClickLabel)
        canClickLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).offset(100)
            maker.leading.equalTo(self.view.snp.leading).offset(labelInsets.left)
            maker.size.equalTo(CGSize(width: canClickLabelSize.width, height: canClickLabelSize.height))
        }
        
        
    }
}
