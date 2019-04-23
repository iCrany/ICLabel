//
//  SizeThatFitsExampleVC.swift
//  ICLabel_Example
//
//  Created by iCrany on 2018/12/11.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation

class SizeThatFitsExampleVC: UIViewController {
    
    struct Constant {
        static let kContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private var testLabel1: UILabel = {
        let v = UILabel()
        v.backgroundColor = UIColor.lightGray
        v.numberOfLines = 0
        return v
    }()
    
    private var testLabel2: UILabel = {
        let v = UILabel()
        v.backgroundColor = UIColor.lightGray
        v.numberOfLines = 0
        return v
    }()
    
    private var testLabel3: ICLabel = {
        let v = ICLabel()
        v.backgroundColor = UIColor.lightGray
        v.numberOfLines = 0
        return v
    }()
    
    private var defaultText: NSMutableAttributedString = {
        let defaultText: NSMutableAttributedString = NSMutableAttributedString(string: "哈中test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]空间的划分空间哈空间和开发的沙发空间撒谎卢卡尔积分卡了咖啡计算的909r90lkjdlfkjlkadsf大方尽快哈房贷卡")
//        defaultText.ic_setFont(UIFont.systemFont(ofSize: 15))
//        defaultText.ic_setParagraphStyle_linespacing(10)
        return defaultText
    }()
    
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
        let maxSize: CGSize = CGSize(width: kScreenWidth - Constant.kContentInsets.left - Constant.kContentInsets.right, height: CGFloat.greatestFiniteMagnitude)
        
        self.testLabel1.attributedText = self.defaultText.copy() as? NSAttributedString
        let testLabel1Rect: CGRect = self.defaultText.boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
        self.view.addSubview(self.testLabel1)
        self.testLabel1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.height.equalTo(ceil(testLabel1Rect.size.height))
        }
        
        self.testLabel2.attributedText = self.defaultText.copy() as? NSAttributedString
        let testLabel2Rect: CGRect = CGRect.zero//self.defaultText.ic_boundRect(with: maxSize, numberOfLines: 0)
        self.view.addSubview(self.testLabel2)
        self.testLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(self.testLabel1.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.height.equalTo(ceil(testLabel2Rect.size.height))
        }
        
        //备注： ic_boundRect: 方法计算出来的宽度以及高度只能用在 ICLabel 控件上
        self.testLabel3.attributedText = self.defaultText.mutableCopy()as? NSMutableAttributedString
        let testLabel3Rect: CGRect = CGRect.zero//self.defaultText.ic_boundRect(with: maxSize, numberOfLines: 0)
        self.view.addSubview(self.testLabel3)
        self.testLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(self.testLabel2.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.height.equalTo(ceil(testLabel3Rect.size.height))
        }
        
        print("testLabel1Rect: \(testLabel1Rect)")
        print("testLabel2Rect: \(testLabel2Rect)")
    }
}
