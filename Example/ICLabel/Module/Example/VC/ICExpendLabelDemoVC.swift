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
//        let testAttrStr = NSMutableAttributedString(string: "暂无介绍")

        let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
        let maxSize: CGSize = CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude)
        testAttrStr.ic_setFont(kLabelFont)

        let linkStr: String = "\(kEllipsisCharacter)全文"
        let seeMore: NSMutableAttributedString = NSMutableAttributedString(string: linkStr)

        let expendLabel: ICLabel = ICLabel()
        expendLabel.font = kLabelFont
        expendLabel.isUserInteractionEnabled = true
        expendLabel.attributedText = seeMore
        expendLabel.backgroundColor = UIColor.clear
        seeMore.ic_setFont(kLabelFont)
        seeMore.ic_setForegroundColor(UIColor.blue,
                                      range: NSRange(location: kEllipsisCharacter.count,
                                                     length: linkStr.count - kEllipsisCharacter.count))
        let expendLabelSize: CGSize = expendLabel.sizeThatFits(maxSize)
        expendLabel.frame = CGRect(origin: .zero, size: expendLabelSize)
        let truncationToken: NSMutableAttributedString = NSMutableAttributedString()
//        truncationToken.ic_appendAttachmentContent(expendLabel,
//                                                   contentInsets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0),
//                                                   alignment: ICAttachmentAlignment_CenterY,
//                                                   referenceFont: expendLabel.font)

        let canClickLabel = ICLabel()
        canClickLabel.isUserInteractionEnabled = true
        canClickLabel.truncationToken = truncationToken
        canClickLabel.backgroundColor = UIColor.lightGray
        canClickLabel.numberOfLines = 4
//        canClickLabel.lineSpacing = 0
        canClickLabel.attributedText = testAttrStr
        let canClickLabelSize = CGRect.zero//testAttrStr.ic_boundRect(with: maxSize, numberOfLines: 4).size
        self.view.addSubview(canClickLabel)
        canClickLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view.snp.top).offset(100)
            maker.leading.equalTo(self.view.snp.leading).offset(labelInsets.left)
            maker.size.equalTo(CGSize(width: canClickLabelSize.width, height: canClickLabelSize.height))
        }

        let hightlight: ICHighlight = ICHighlight()
//        hightlight.tapAction = {
//            canClickLabel.numberOfLines = 0
//            let canClickLabelSize = canClickLabel.sizeThatFits(maxSize)
//            canClickLabel.snp.updateConstraints { (maker) in
//                maker.size.equalTo(canClickLabelSize)
//            }
//        }
//        seeMore.ic_setHightlight(hightlight, range: NSRange(location: kEllipsisCharacter.count, length: seeMore.length - kEllipsisCharacter.count))
        

        let m80Label: M80AttributedLabel = M80AttributedLabel()
        m80Label.numberOfLines = canClickLabel.numberOfLines
//        m80Label.lineSpacing = canClickLabel.lineSpacing
        m80Label.backgroundColor = UIColor.lightGray
        m80Label.attributedText = testAttrStr
        m80Label.font = kLabelFont
        let m80Size: CGSize = m80Label.sizeThatFits(maxSize)
        self.view.addSubview(m80Label)
        m80Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(canClickLabel.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(labelInsets.left)
            maker.size.equalTo(m80Size)
        }

        let attrStr: NSMutableAttributedString = testAttrStr.mutableCopy() as! NSMutableAttributedString
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = m80Label.lineSpacing
        attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                              range: NSRange(location: 0, length: attrStr.length))
        let yyLabel: YYLabel = YYLabel()
        yyLabel.attributedText = attrStr
        yyLabel.font = kLabelFont
        yyLabel.backgroundColor = m80Label.backgroundColor
        yyLabel.numberOfLines = UInt(canClickLabel.numberOfLines)
        let yyLabelSize: CGSize = yyLabel.sizeThatFits(maxSize)
        self.view.addSubview(yyLabel)
        yyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(m80Label.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(labelInsets.left)
            maker.size.equalTo(yyLabelSize)
        }

        let systemLabel: UILabel = UILabel()
        self.view.addSubview(systemLabel)
        systemLabel.attributedText = attrStr
        systemLabel.numberOfLines = m80Label.numberOfLines
        systemLabel.font = kLabelFont
        let systemSize: CGSize = systemLabel.sizeThatFits(maxSize)
        systemLabel.backgroundColor = UIColor.lightGray
        systemLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(yyLabel.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(labelInsets.left)
            maker.size.equalTo(systemSize)
        }
    }
}
