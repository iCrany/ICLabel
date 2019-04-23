//
//  ICLineBreakModeDemoVC.swift
//  ICLabel
//
//  Created by iCrany on 2018/8/14.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import YYText
import UIKit
import ICLabel

//swiftlint:disable force_cast
class ICLineBreakModeDemoVC: UIViewController {
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
        self.view.backgroundColor = .white

        let kContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        //没有提供 NSMutableParagraphStyle 是会显示 ... 出来的，但是如果提供了 NSMutableParagraphStyle 对象的话就不会显示 ... 出来的，这个逻辑需要注意一下

        let attr = NSMutableAttributedString(string: "   This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,This is a long test text,")

        let descLabel = UILabel()
        descLabel.numberOfLines = 2
        descLabel.attributedText = attr
        descLabel.backgroundColor = UIColor.lightGray
        self.view.addSubview(descLabel)
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.centerX.equalToSuperview()
            maker.left.equalToSuperview().offset(kContentInsets.left)
            maker.right.equalToSuperview().offset(-kContentInsets.right)
        }

        let applyParagraphStyleAttr: NSMutableAttributedString = attr.mutableCopy() as! NSMutableAttributedString
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail //该行设置与不设置效果都是一样的
        applyParagraphStyleAttr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], range: NSRange(location: 0, length: applyParagraphStyleAttr.length))

        let descLabel2 = UILabel()
        descLabel2.numberOfLines = 1
        descLabel2.backgroundColor = UIColor.lightGray
        descLabel2.alpha = 0.5
        descLabel2.attributedText = applyParagraphStyleAttr
//        descLabel2.lineBreakMode = .byTruncatingTail //该参数一定要放置在 attributedText 之后才知道， 并且不能同时在 NSParagraphStyle.lineBreakMode = .byTruncatingTail
        
//        let size = descLabel2.sizeThatFits(CGSize(width: kScreenWidth - kContentInsets.left - kContentInsets.right,
//                                                  height: CGFloat.greatestFiniteMagnitude))
        
        let testSize = applyParagraphStyleAttr.boundingRect(with: CGSize(width: kScreenWidth - kContentInsets.left - kContentInsets.right,
                                                                         height: CGFloat.greatestFiniteMagnitude),
                                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                            context: nil)
        self.view.addSubview(descLabel2)
        descLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(descLabel.snp.bottom).offset(10)
            maker.leading.equalTo(descLabel)
//            maker.size.equalTo(size)
            maker.size.equalTo(testSize.size)
        }

        //TODO: YYLabel 支持 NSParagraphStyle 的类型，并且在设置了行数限制的前提下会自动的添加 ...，目前 UILabel 以及 M80 控件都是不支持的
        let yyLabel = YYLabel()
        yyLabel.numberOfLines = UInt(descLabel.numberOfLines)
        yyLabel.backgroundColor = UIColor.lightGray
        yyLabel.attributedText = applyParagraphStyleAttr
        let yyLabelSize = yyLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - kContentInsets.left - kContentInsets.right,
                                                      height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(yyLabel)
        yyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(descLabel2.snp.bottom).offset(10)
            maker.leading.equalTo(descLabel)
            maker.size.equalTo(yyLabelSize)
        }

        let icLabel = ICLabel()
        icLabel.numberOfLines = descLabel.numberOfLines
        icLabel.backgroundColor = UIColor.lightGray
        icLabel.attributedText = applyParagraphStyleAttr
//        icLabel.font = UIFont.systemFont(ofSize: 20)
        let icLabelSize = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kContentInsets.left - kContentInsets.right, height: CGFloat.greatestFiniteMagnitude))
        self.view.addSubview(icLabel)
        icLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(yyLabel.snp.bottom).offset(10)
            maker.leading.equalTo(descLabel)
            maker.size.equalTo(icLabelSize)
        }
    }
}
