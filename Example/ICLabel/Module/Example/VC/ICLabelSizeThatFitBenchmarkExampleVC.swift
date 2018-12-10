//
//  ICLabelSizeThatFitExamleVC.swift
//  ICLabel_Example
//
//  Created by iCrany on 2018/12/10.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation

class ICLabelSizeThatFitBenchmarkExampleVC: UIViewController {
    
    struct Constant {
        static let kContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private var inputTextView: UITextView = { //输入测试字符的
        let v = UITextView()
        v.backgroundColor = UIColor.lightGray
        v.textColor = UIColor.black
        return v
    }()
    
    private var startBtn: UIButton = {
        let v = UIButton(type: .custom)
        v.setTitle("计算", for: .normal)
        v.setTitleColor(UIColor.black, for: .normal)
        v.backgroundColor = UIColor.blue
        return v
    }()
    
    private var inputCalNumberTextField: UITextField = {
        let v = UITextField()
        v.keyboardType = .numberPad
        v.text = "10000"
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    private var resultTextView: UITextView = { //显示计算结果的
        let v = UITextView()
        v.backgroundColor = UIColor.lightGray
        v.textColor = UIColor.red
        return v
    }()
    
    private var defaultText: NSMutableAttributedString = {
        let defaultText: NSMutableAttributedString = NSMutableAttributedString(string: "哈中test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀速度快回复肯定会开发可来得及分类的空间烂大街法律框架爱离开对方就流口水的了肯定是解放路口就冻死了卡减肥了空间了空间大浪费空间了空间撒蝶恋蜂狂氪金大佬开房记录卡机了看见对方立刻据了解")
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
        
        self.view.addSubview(self.inputTextView)
        self.inputTextView.attributedText = self.defaultText
        self.inputTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.height.equalTo(350)
        }
        
        self.view.addSubview(self.inputCalNumberTextField)
        self.inputCalNumberTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.top.equalTo(self.inputTextView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        self.view.addSubview(self.startBtn)
        self.startBtn.addTarget(self, action: #selector(startBtnAction), for: .touchUpInside)
        self.startBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.inputCalNumberTextField.snp.centerY)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.size.equalTo(CGSize(width: 80, height: 44))
        }
        
        self.view.addSubview(self.resultTextView)
        self.resultTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Constant.kContentInsets.left)
            make.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            make.bottom.equalToSuperview().offset(-kBottomOffset)
//            make.top.equalTo(self.inputCalNumberTextField.snp.bottom).offset(50)
            make.height.equalTo(200)
        }
    }
    
    //MARK: - Event response
    @objc func startBtnAction() {
        self.resultTextView.text = "" //reset
        
        let count = Int(self.inputCalNumberTextField.text ?? "") ?? 0
        
        let size = CGSize(width: kScreenWidth - Constant.kContentInsets.left - Constant.kContentInsets.right, height: CGFloat.greatestFiniteMagnitude)
        
        let testAttrStr: NSMutableAttributedString = self.defaultText.mutableCopy() as! NSMutableAttributedString
        let resultString: NSMutableString = NSMutableString()
        
        var startTime: Double = CFAbsoluteTimeGetCurrent()
        for index in 0..<count {
            let rect = testAttrStr.ic_boundRect(with: size, numberOfLines: 0)
            if index == 0 {
                print("[xxx0] rect: \(rect)")
            }
        }
        var endTime: Double = CFAbsoluteTimeGetCurrent()
        print("[ic_boundRect] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        resultString.append("[ic_boundRect] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        
        startTime = CFAbsoluteTimeGetCurrent()
        for index in 0..<count {
            let rect = testAttrStr.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            if index == 0 {
                print("[xxx1] rect: \(rect)")
            }
        }
        endTime = CFAbsoluteTimeGetCurrent()
        print("[boundingRect] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        resultString.append("\n")
        resultString.append("[ic_boundRect] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        
        
        startTime = CFAbsoluteTimeGetCurrent()
        for index in 0..<count {
            let testLabel = UILabel()
            testLabel.attributedText = defaultText.copy() as? NSAttributedString
            let rect = testLabel.sizeThatFits(size)
            if index == 0 {
                print("[xxx2] rect: \(rect)")
            }
        }
        endTime = CFAbsoluteTimeGetCurrent()
        print("[sizeThatFits] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        resultString.append("\n")
        resultString.append("[sizeThatFits] cost: \(endTime - startTime) startTime: \(startTime) endTime: \(endTime)")
        
        self.resultTextView.text = String(resultString)
        
    }
}
