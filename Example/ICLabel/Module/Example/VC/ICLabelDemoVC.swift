//
//  ICLabelDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/8/16.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

//swiftlint:disable force_cast
class ICLabelDemoVC: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.white

        let testAttrStr = NSMutableAttributedString(string: "  test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ（￣▽￣）ｄｂ（￣▽￣）ｄｂ（￣▽￣）ｄｂ（￣▽￣）ｄ(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(￣３￣)a(￣３￣)a(￣３￣)a(￣３￣)a(￣３￣)a╰(￣▽￣)╭╰(￣▽￣)╭╰(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀")

        let hasParagraphStyleAttrStr = testAttrStr.mutableCopy() as! NSMutableAttributedString

        let labelInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let kLabelFont: UIFont = UIFont.systemFont(ofSize: 15)

        let testLabel = ICLabel()
        self.view.addSubview(testLabel)
        testLabel.numberOfLines = 3 //测试行数的限制逻辑
        testLabel.backgroundColor = UIColor.lightGray
//        testLabel.font = UIFont.systemFont(ofSize: 20)
//        testLabel.font = UIFont.init(name: "DINCondensed-bold", size: 20)
//        testLabel.lineSpacing = 20;//支持行间距的设置
        testLabel.attributedText = hasParagraphStyleAttrStr
        let testLabelSize = testLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right,
                                                          height: CGFloat.greatestFiniteMagnitude))
        testLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(labelInsets.left)
            maker.size.equalTo(testLabelSize)
        }

        let judgeTestLabel = ICLabel()
        judgeTestLabel.attributedText = testAttrStr
        judgeTestLabel.backgroundColor = UIColor.lightGray
        let juedgeTestLabelSize = judgeTestLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(judgeTestLabel)
        judgeTestLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(testLabel.snp.bottom).offset(20)
            maker.leading.equalTo(testLabel)
            maker.size.equalTo(juedgeTestLabelSize)
        }

        let anotherTestAttrStr: NSMutableAttributedString = testAttrStr.mutableCopy() as! NSMutableAttributedString
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = testLabel.lineSpacing //设置行间距的测试
        anotherTestAttrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                          NSAttributedString.Key.foregroundColor: UIColor.black,
                                          NSAttributedString.Key.paragraphStyle: paragraphStyle
            ],
                                         range: NSRange(location: 0, length: anotherTestAttrStr.length))
        //貌似是系统的一个 bug, numberOfLines = 3 ， lineSpacing = 20, 这个时候文字中就不会显示 ... 出来了。。。
        let anotherTestLabel = UILabel()
        anotherTestLabel.attributedText = anotherTestAttrStr
//        anotherTestLabel.textColor = testLabel.textColor
        anotherTestLabel.numberOfLines = testLabel.numberOfLines
        anotherTestLabel.backgroundColor = UIColor.groupTableViewBackground
        let anotherTestLabelSize = anotherTestLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(anotherTestLabel)
        anotherTestLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(judgeTestLabel.snp.bottom).offset(20)
            maker.leading.equalTo(testLabel)
            maker.size.equalTo(anotherTestLabelSize)
        }

        let linkStr: String = "\(kEllipsisCharacter)全文"

        let seeMore: NSMutableAttributedString = NSMutableAttributedString(string: linkStr)
//        seeMore.ic_setFont(kLabelFont)
//        seeMore.ic_setForegroundColor(UIColor.red, range: NSRange(location: kEllipsisCharacter.count, length: linkStr.count - kEllipsisCharacter.count))
        let expendLabel: ICLabel = ICLabel()
        expendLabel.attributedText = seeMore
//        expendLabel.textColor = UIColor.blue
        expendLabel.backgroundColor = UIColor.red
        let expendLabelSize: CGSize = expendLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        expendLabel.frame = CGRect(origin: .zero, size: expendLabelSize)

        let truncationToken: NSMutableAttributedString = NSMutableAttributedString()
//        truncationToken.ic_appendAttachmentContent(expendLabel,
//                                                   contentInsets: .zero,
//                                                   alignment: ICAttachmentAlignment_CenterY,
//                                                   referenceFont: expendLabel.font)

        let canClickLabel = ICLabel()
        canClickLabel.truncationToken = truncationToken
        canClickLabel.backgroundColor = UIColor.lightGray
        canClickLabel.numberOfLines = 3
        canClickLabel.attributedText = testAttrStr
        let canClickLabelSize = canClickLabel.sizeThatFits(CGSize(width: kScreenWidth - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(canClickLabel)
        canClickLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(anotherTestLabel.snp.bottom).offset(20)
            maker.leading.equalTo(testLabel)
            maker.size.equalTo(canClickLabelSize)
        }
    }
}
