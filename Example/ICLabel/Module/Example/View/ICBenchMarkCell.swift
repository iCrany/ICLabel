//
//  ICBenchMarkCell.swift
//  iOSExample
//
//  Created by iCrany on 2018/10/11.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

class ICBenchMarkCell: UITableViewCell {

    struct Constant {
        static let kFont: UIFont = UIFont.systemFont(ofSize: 10)
        static let kContentInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    private var icLabel: ICLabel = {
        let v = ICLabel()
//        v.font = Constant.kFont
//        v.lineSpacing = 10
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    private func setupUI() {
        self.contentView.addSubview(self.icLabel)
        self.icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Constant.kContentInsets.top)
            maker.bottom.equalToSuperview().offset(-Constant.kContentInsets.bottom)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
        }
    }

    func update(str: String) {
        let attrStr = NSMutableAttributedString(string: str)
//        attrStr.ic_setFont(Constant.kFont)
        self.icLabel.attributedText = attrStr

    }

    class func getCellSize(str: String) -> CGSize {
        let attrStr = NSMutableAttributedString(string: str)
//        attrStr.ic_setFont(Constant.kFont)
        let icLabel: ICLabel = ICLabel()
        icLabel.attributedText = attrStr
        let size = icLabel.sizeThatFits(CGSize(width: kScreenWidth, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: Constant.kContentInsets.left + size.width + Constant.kContentInsets.right, height: Constant.kContentInsets.top + size.height + Constant.kContentInsets.bottom)
    }
}
