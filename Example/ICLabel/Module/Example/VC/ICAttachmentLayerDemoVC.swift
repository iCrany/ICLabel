//
//  ICAttachmentLayerDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/29.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

//swiftlint:disable force_cast
class ICAttachmentLayerDemoVC: UIViewController {

    struct Constant {
        static let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let kLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    }

    private var icLabel: ICLabel = {
        let v = ICLabel()
        return v
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setupUI()
    }

    private func setupUI() {

        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "哈中test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀速度快回复肯定会开发可来得及分类的空间烂大街法律框架爱离开对方就流口水的了肯定是解放路口就冻死了卡减肥了空间了空间大浪费空间了空间撒蝶恋蜂狂氪金大佬开房记录卡机了看见对方立刻据了解")

        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.frame = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
        let icAttrText: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
        icAttrText.ic_insertAttachmentContent(layer, contentInsets: .zero, alignment: ICAttachmentAlignment_CenterY, referenceFont: Constant.kLabelFont, at: 0)

        self.view.addSubview(self.icLabel)
        self.icLabel.backgroundColor = UIColor.lightGray
        self.icLabel.attributedString = icAttrText.mutableCopy() as? NSMutableAttributedString
        let size: CGSize = self.icLabel.sizeThatFits(CGSize(width: kScreenWidth - Constant.kLabelInsets.left - Constant.kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(Constant.kLabelInsets.left)
            maker.size.equalTo(size)
        }
    }
}
