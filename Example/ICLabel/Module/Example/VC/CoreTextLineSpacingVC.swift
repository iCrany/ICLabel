//
//  CoreTextLineSpacingVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/2.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import UIKit

class CoreTextLineSpacingVC: UIViewController {

    struct Constant {
        static let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        static let kContentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        static let kCaclUseSizeThatFitsPrefix: String = "sizeThatFits 计算的高度: "
        static let kCalcUseBoundsPrefix: String = "boundingRect 计算的高度："
        static let kCalcUseCoreTextPrefix: String = "CoreText 计算的高度:"
    }

    private lazy var textView: UITextView = {
        let v = UITextView()
        v.text = "有关我立志写作是个反熵过程，还有进一步"
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    private lazy var lineSpacingDescLabel: UILabel = {
        let v = UILabel()
        v.text = "行间距: "
        return v
    }()

    private lazy var lineSpecingTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = UIColor.lightGray
        v.text = "10"
        return v
    }()

    private lazy var calcHeightLabel1: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        return v
    }()

    private lazy var calcHeightLabel2: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        return v
    }()

    private lazy var calcHeightLabel3: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        return v
    }()

    private lazy var showLabel: UILabel = { //使用 sizeThatFits 计算的高度
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    private lazy var showLabel2: UILabel = { //使用 boundRect 计算的高度
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    private lazy var showLabel3: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = UIColor.lightGray
        return v
    }()

    private lazy var calcBtn: UIButton = {
        let v = UIButton()
        v.backgroundColor = UIColor.lightGray
        v.setTitle("计算", for: UIControl.State.normal)
        return v
    }()

    private var setMinAndMaxLineHeightDescLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        v.text = "是否设置 minimumLineHeight 和 maximumLineHeight 参数："
        return v
    }()

    private var setMinAndMaxLineHeightSwitch: UISwitch = {
        let v = UISwitch()
        v.isOn = true
        return v
    }()

    private var setDefaultFontInAttrDescLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        v.text = "是否设置 NSAttributedStringKey.font 参数："
        return v
    }()

    private var setDefaultFontInAttrSwitch: UISwitch = {
        let v = UISwitch()
        v.isOn = true
        return v
    }()

    private var setLineHeightMultipleInsteadOfLineSpacingDescLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: 11)
        v.text = "使用 lineHeightMultiple 而非 lineSpacing: "
        return v
    }()

    private var setLineHeightMultipleInsteadOfLineSpacingSwitch: UISwitch = {
        let v = UISwitch()
        v.isOn = false
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

        self.view.addSubview(self.textView)
        self.textView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(150)
        }

        self.view.addSubview(self.lineSpacingDescLabel)
        self.lineSpacingDescLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.top.equalTo(self.textView.snp.bottom).offset(30)
            maker.width.equalTo(60)
        }

        self.view.addSubview(self.lineSpecingTextField)
        self.lineSpecingTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.lineSpacingDescLabel.snp.right).offset(20)
            maker.centerY.equalTo(self.lineSpacingDescLabel.snp.centerY)
            maker.size.equalTo(CGSize(width: 100, height: 40))
        }

        self.view.addSubview(self.calcBtn)
        self.calcBtn.addTarget(self, action: #selector(calcBtnAction), for: .touchUpInside)
        self.calcBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.centerY.equalTo(self.lineSpacingDescLabel.snp.centerY)
            maker.size.equalTo(CGSize(width: 44, height: 40))
        }

        self.view.addSubview(self.setDefaultFontInAttrDescLabel)
        self.setDefaultFontInAttrDescLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.lineSpacingDescLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.height.equalTo(28)
        }

        self.view.addSubview(self.setDefaultFontInAttrSwitch)
        self.setDefaultFontInAttrSwitch.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.centerY.equalTo(self.setDefaultFontInAttrDescLabel.snp.centerY)
        }

        self.view.addSubview(self.setMinAndMaxLineHeightDescLabel)
        self.setMinAndMaxLineHeightDescLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.setDefaultFontInAttrDescLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.height.equalTo(28)
        }

        self.view.addSubview(self.setMinAndMaxLineHeightSwitch)
        self.setMinAndMaxLineHeightSwitch.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.centerY.equalTo(self.setMinAndMaxLineHeightDescLabel.snp.centerY)
        }

        self.view.addSubview(self.setLineHeightMultipleInsteadOfLineSpacingDescLabel)
        self.setLineHeightMultipleInsteadOfLineSpacingDescLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.top.equalTo(self.setMinAndMaxLineHeightDescLabel.snp.bottom).offset(10)
            maker.height.equalTo(28)
        }

        self.view.addSubview(self.setLineHeightMultipleInsteadOfLineSpacingSwitch)
        self.setLineHeightMultipleInsteadOfLineSpacingSwitch.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.centerY.equalTo(self.setLineHeightMultipleInsteadOfLineSpacingDescLabel.snp.centerY)
        }

        self.view.addSubview(self.calcHeightLabel1)
        self.calcHeightLabel1.text = Constant.kCaclUseSizeThatFitsPrefix
        self.calcHeightLabel1.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.setLineHeightMultipleInsteadOfLineSpacingDescLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(44)
        }

        self.view.addSubview(self.calcHeightLabel2)
        self.calcHeightLabel2.text = Constant.kCalcUseBoundsPrefix
        self.calcHeightLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.calcHeightLabel1.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(44)
        }

        self.view.addSubview(self.calcHeightLabel3)
        self.calcHeightLabel3.text = Constant.kCalcUseCoreTextPrefix
        self.calcHeightLabel3.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.calcHeightLabel2.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(44)
        }

        self.view.addSubview(self.showLabel)
        self.showLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.calcHeightLabel3.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(0)
        }

        self.view.addSubview(self.showLabel2)
        self.showLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.showLabel.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(0)
        }

        self.view.addSubview(self.showLabel3)
        self.showLabel3.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.showLabel2.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(Constant.kContentInsets.left)
            maker.right.equalToSuperview().offset(-Constant.kContentInsets.right)
            maker.height.equalTo(0)
        }
    }

    @objc private func calcBtnAction() {
        let lineSpacingStr = self.lineSpecingTextField.text
        let lineSapcingNum = Int(lineSpacingStr ?? "")
        guard let lineSpacing = lineSapcingNum else {
            return
        }

        self.view.endEditing(true)

        let defaultFont: UIFont = UIFont.systemFont(ofSize: 17)

        let attrStr = NSMutableAttributedString(string: self.textView.text)
        let paragraphStyle = NSMutableParagraphStyle()
        if self.setMinAndMaxLineHeightSwitch.isOn {
            paragraphStyle.minimumLineHeight = defaultFont.lineHeight
            paragraphStyle.maximumLineHeight = defaultFont.lineHeight
        }

        if self.setLineHeightMultipleInsteadOfLineSpacingSwitch.isOn {
            if lineSpacing == 0 {
                paragraphStyle.lineSpacing = 0.0
                paragraphStyle.lineHeightMultiple = 0
            } else {
                paragraphStyle.lineSpacing = 1
                paragraphStyle.lineHeightMultiple = CGFloat(lineSpacing)
            }
        } else {
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        }

        if self.setDefaultFontInAttrSwitch.isOn {
            attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                   NSAttributedString.Key.font: defaultFont], range: NSRange(location: 0, length: attrStr.length))
        } else {
            attrStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attrStr.length))
        }

        self.showLabel.attributedText = attrStr
        self.showLabel2.attributedText = attrStr
        self.showLabel3.attributedText = attrStr
        self.showLabel3.clipsToBounds = true

        let maxSize = CGSize(width: Constant.kScreenWidth - Constant.kContentInsets.left - Constant.kContentInsets.right, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = self.showLabel.sizeThatFits(maxSize)

        let boundsRect = attrStr.boundingRect(with: maxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], context: nil)

        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attrStr)
        let calcLabelSizeWithCoreText = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attrStr.length), nil, maxSize, nil)

        self.calcHeightLabel1.text = "\(Constant.kCaclUseSizeThatFitsPrefix) \(labelSize.height)"
        self.calcHeightLabel2.text = "\(Constant.kCalcUseBoundsPrefix) \(boundsRect.size.height) lineHeight: \(defaultFont.lineHeight)"
        self.calcHeightLabel3.text = "\(Constant.kCalcUseCoreTextPrefix) \(calcLabelSizeWithCoreText.height)"

        self.showLabel.snp.updateConstraints { (maker) in
            maker.height.equalTo(labelSize.height)
        }

        self.showLabel2.snp.updateConstraints { (maker) in
            maker.height.equalTo(boundsRect.size.height)
        }

        self.showLabel3.snp.updateConstraints { (maker) in
            maker.height.equalTo(calcLabelSizeWithCoreText.height)
        }

    }
}
