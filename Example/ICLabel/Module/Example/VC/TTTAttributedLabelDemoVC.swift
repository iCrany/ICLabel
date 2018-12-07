//
//  TTTAttributedLabelDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/18.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel
import TTTAttributedLabel

class TTTAttributedLabelDemoVC: UIViewController {
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
        let testAttrStr = NSMutableAttributedString(string: "  test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ（￣▽￣）ｄｂ（￣▽￣）ｄｂ（￣▽￣）ｄｂ（￣▽￣）ｄ(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(～￣▽￣)～(￣３￣)a(￣３￣)a(￣３￣)a(￣３￣)a(￣３￣)a╰(￣▽￣)╭╰(￣▽￣)╭╰(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀")

        testAttrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: testAttrStr.length))
        let screenSize = UIScreen.main.bounds.size
        let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let label: TTTAttributedLabel = TTTAttributedLabel(frame: CGRect.zero)
        label.attributedText = testAttrStr
        label.numberOfLines = 3
        label.attributedTruncationToken = NSAttributedString(string: "++++_+++", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        label.backgroundColor = UIColor.lightGray
        let size = label.sizeThatFits(CGSize(width: screenSize.width - labelInsets.left - labelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(labelInsets.left)
            maker.top.equalToSuperview().offset(100)
            maker.size.equalTo(size)
        }
    }
}
