//
//  YYLabelTouchDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/14.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel
import YYText

class YYLabelTouchDemoVC: UIViewController {

    struct Constant {
        static let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let kLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    }

    fileprivate var label: YYLabel = {
        let label: YYLabel = YYLabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
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

        let testAttrStr = NSMutableAttributedString(string: "  test")

        let testAttrStr2 = NSMutableAttributedString(string: "中")
        testAttrStr2.yy_setTextHighlight(NSRange(location: 0, length: 1),
                                         color: UIColor.blue,
                                         backgroundColor: nil,
                                         userInfo: nil,
                                         tapAction: { (_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in
                                            print("this is highlight tap action...")
        })

        let testAttrStr3 = NSMutableAttributedString(string: "文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣")

        let seeMoreAtr: NSMutableAttributedString = NSMutableAttributedString(string: "\(kEllipsisCharacter)展开")
        seeMoreAtr.yy_setTextHighlight(NSRange(location: kEllipsisCharacter.count, length: seeMoreAtr.length - kEllipsisCharacter.count),
                                       color: UIColor.blue,
                                       backgroundColor: UIColor.clear,
                                       userInfo: nil,
                                       tapAction: { (_: UIView, _: NSAttributedString, _: NSRange, _: CGRect) in
                                        print("this is highlight tap action...")
        })

        testAttrStr.append(testAttrStr2)
        testAttrStr.append(testAttrStr3)
        testAttrStr.append(seeMoreAtr)

        self.view.addSubview(label)
        label.backgroundColor = UIColor.lightGray
        label.attributedText = testAttrStr
        self.addSeeMoreBtn()
        label.numberOfLines = 3
        label.font = Constant.kLabelFont
        let size = label.sizeThatFits(CGSize(width: kScreenWidth - Constant.kLabelInsets.left - Constant.kLabelInsets.right,
                                             height: CGFloat.greatestFiniteMagnitude))
        label.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.leading.equalToSuperview().offset(Constant.kLabelInsets.left)
            maker.size.equalTo(size)
        }

        let str = NSMutableAttributedString(string: "  test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣")

        let testLabel: YYLabel = YYLabel()
        testLabel.backgroundColor = UIColor.lightGray
        testLabel.attributedText = str
        testLabel.numberOfLines = 0
        testLabel.font = Constant.kLabelFont
        let testLabelSize: CGSize = testLabel.sizeThatFits(CGSize(width: kScreenWidth - Constant.kLabelInsets.left - Constant.kLabelInsets.right,
                                                                  height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(testLabel)
        testLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(Constant.kLabelInsets.left)
            maker.size.equalTo(testLabelSize)
        }

    }

    private func addSeeMoreBtn() {
        let text: NSMutableAttributedString = NSMutableAttributedString(string: "\(kEllipsisCharacter)展开")

        let hightlight: YYTextHighlight = YYTextHighlight()
        hightlight.setColor(UIColor.black)
        hightlight.tapAction = { [weak self] (container: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) in
            guard let sSelf = self else { return }
            let label: YYLabel = sSelf.label
            label.numberOfLines = 0
            let newSize = label.sizeThatFits(CGSize(width: kScreenWidth - Constant.kLabelInsets.left - Constant.kLabelInsets.right,
                                                    height: CGFloat.greatestFiniteMagnitude))
            label.snp.updateConstraints({ (maker) in
                maker.top.equalToSuperview().offset(100)
                maker.leading.equalToSuperview().offset(Constant.kLabelInsets.left)
                maker.size.equalTo(newSize)
            })
        }

        text.yy_setTextHighlight(hightlight, range: NSRange(location: 0, length: text.length))
        text.yy_font = Constant.kLabelFont

        let seeMore: YYLabel = YYLabel()
        seeMore.attributedText = text
        seeMore.font = Constant.kLabelFont
        seeMore.backgroundColor = UIColor.green
        let seeMoreSize: CGSize = seeMore.sizeThatFits(CGSize(width: kScreenWidth - Constant.kLabelInsets.left - Constant.kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        print("seeMoreSize: \(seeMoreSize)")
        seeMore.frame = CGRect(origin: .zero, size: seeMoreSize)

        let truncationToken: NSAttributedString = NSAttributedString.yy_attachmentString(withContent: seeMore,
                                                                                         contentMode: .center,
                                                                                         attachmentSize: seeMore.frame.size,
                                                                                         alignTo: Constant.kLabelFont,
                                                                                         alignment: .center)
        self.label.truncationToken = truncationToken
    }
}
