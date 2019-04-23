//
//  ICLineSpacingDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/10/8.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

class ICLineSpacingDemoVC: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kLabelFont: UIFont = UIFont.systemFont(ofSize: 13) //L5 - 26px - regular
        let kTitleLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 17) //L11 - 34px bold

        let text: String = "庄子与惠子游于濠梁之上。庄子曰：“鯈鱼出游从容，是鱼之乐也。”惠子曰：“子非鱼，安知鱼之乐？”庄子曰：“子非我，安知我不知鱼之乐？”惠子曰：“我非子，固不知子矣；子固非鱼也，子之不知鱼之乐全矣！”庄子曰：“请循其本。子曰‘汝安知鱼乐’云者，既已知吾知之而问我。我知之濠上也。”"

        let attrText = NSMutableAttributedString(string: text)
        let icLabel: ICLabel = ICLabel()
        icLabel.attributedText = attrText.mutableCopy() as? NSMutableAttributedString
//        icLabel.font = kLabelFont
//        icLabel.lineSpacing = 5
        icLabel.isUserInteractionEnabled = false
        icLabel.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel)
        let size: CGSize = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.right.equalToSuperview().offset(-kLabelInsets.right)
            maker.height.equalTo(size.height)
        }

        let titleAttrText = NSMutableAttributedString(string: text)
        let titleLabel: ICLabel = ICLabel()
        titleLabel.attributedText = titleAttrText
//        titleLabel.font = kTitleLabelFont
//        titleLabel.lineSpacing = 6//(6 - (kTitleLabelFont.lineHeight - kTitleLabelFont.pointSize))
        titleLabel.backgroundColor = UIColor.clear
        self.view.addSubview(titleLabel)
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.right.equalToSuperview().offset(-kLabelInsets.right)
            maker.height.equalTo(titleLabelSize.height)
        }

        let newText: String = "ABCD哈哈" //使用 systemAttrText.ic_setParagraphStyle_linespacing(50)， 会有多余的间隔出来
        let systemAttrText = NSMutableAttributedString(string: newText)
//        systemAttrText.ic_setFont(kLabelFont)
//        systemAttrText.ic_setParagraphStyle_linespacing(50, maxWidth: kScreenWidth - kLabelInsets.left - kLabelInsets.right, with: kLabelFont) //修复系统 lineSpacing 问题
        let systemLabel: UILabel = UILabel()
        systemLabel.attributedText = systemAttrText
        systemLabel.backgroundColor = UIColor.lightGray
        systemLabel.numberOfLines = 0
        self.view.addSubview(systemLabel)
        let systemLabelSize = systemLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        systemLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(systemLabelSize)
        }
    }
}
