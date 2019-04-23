//
//  ICAttachmentLabelDemoVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/9/12.
//  Copyright © 2018年 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

enum ICAttachmentDemoType {
    case example1 //主要是 UIView / UIImage 的 alignment demo测试
    case example2 //主要是 图文混排的实际应用测试，例如是否正确显示 ..., 在文本前面添加图片，在文本背后添加图片，文本的 lineSpacing 参数的设置
    case example3 //主要用于测试 UIImage 的布局使用
}

//swiftlint:disable force_cast
class ICAttachmentLabelDemoVC: UIViewController {

    private var attachmentDemoType: ICAttachmentDemoType

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(attachmentDemoType: ICAttachmentDemoType = .example1) {
        self.attachmentDemoType = attachmentDemoType
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = UIColor.white

        switch self.attachmentDemoType {
        case .example1:
            self.setupExample1UI()
        case .example2:
            self.setupExample2UI()
        case .example3:
            self.setupExample3UI()
        }
    }

    private func setupExample1UI() {

        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "abg123展开可代发辽阔的积分dkd hfkjahdfjadiuyreiuhsahdkjfhkjhkfsdahsfjh")
        let appendAttrText: NSAttributedString = NSAttributedString(string: "--last line change")

        let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        let kContentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let kCustomViewSize: CGSize = CGSize(width: 40, height: 40)
        let kLineSpacing: CGFloat = 10

        let image = UIImage(named: "jucat.jpeg")
//        let attachment: ICLabelAttachment = ICLabelAttachment(content: image, contentInset: kContentInset, alignment: ICAttachmentAlignment_CenterY, referenceFont: UIFont.systemFont(ofSize: 15))
//        attachment.limitSize = CGSize(width: 50, height: 50)

        let testAttr: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        testAttr.ic_append(attachment)
        testAttr.append(appendAttrText)

        let icLabel: ICLabel = ICLabel()
        icLabel.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel)
        icLabel.attributedText = testAttr
//        icLabel.lineSpacing = kLineSpacing
        let size = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size)
        }

        let customView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        customView.backgroundColor = UIColor.blue
//        let viewAttachment: ICLabelAttachment = ICLabelAttachment(content: customView,
//                                                             contentInset: kContentInset,
//                                                                alignment: ICAttachmentAlignment_Top,
//                                                                referenceFont: UIFont.systemFont(ofSize: 15))

        let testAttr2: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        testAttr2.ic_append(viewAttachment)
        testAttr2.append(appendAttrText)

        let icLabel2: ICLabel = ICLabel()
        icLabel2.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel2)
        icLabel2.font = UIFont.systemFont(ofSize: 20)
//        icLabel2.lineSpacing = kLineSpacing
        icLabel2.attributedText = testAttr2
        let size2: CGSize = icLabel2.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size2)
        }

        let customView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        customView2.backgroundColor = UIColor.blue
//        let viewAttachment2: ICLabelAttachment = ICLabelAttachment(content: customView2,
//                                                                  contentInset: kContentInset,
//                                                                  alignment: ICAttachmentAlignment_CenterY,
//                                                                  referenceFont: UIFont.systemFont(ofSize: 20))
        let testAttr3: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        testAttr3.ic_append(viewAttachment2)
        testAttr3.append(appendAttrText)

        let icLabel3: ICLabel = ICLabel()
        icLabel3.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel3)
        icLabel3.font = UIFont.systemFont(ofSize: 20)
//        icLabel3.lineSpacing = kLineSpacing
        icLabel3.attributedText = testAttr3
        let size3: CGSize = icLabel3.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel3.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel2.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size3)
        }

        let customView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        customView3.backgroundColor = UIColor.blue
//        let viewAttachment3: ICLabelAttachment = ICLabelAttachment(content: customView3,
//                                                                   contentInset: kContentInset,
//                                                                   alignment: ICAttachmentAlignment_Bottom,
//                                                                   referenceFont: UIFont.systemFont(ofSize: 20))
        let testAttr4: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        testAttr4.ic_append(viewAttachment3)
        testAttr4.append(appendAttrText)

        let icLabel4: ICLabel = ICLabel()
        icLabel4.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel4)
        icLabel4.font = UIFont.systemFont(ofSize: 20)
//        icLabel4.lineSpacing = kLineSpacing
        icLabel4.attributedText = testAttr4
        let size4: CGSize = icLabel4.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel4.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel3.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size4)
        }

        //支持 UIView 里面添加图片的形式
        let customView4: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        let customImgView: UIImageView = UIImageView(image: UIImage(named: "jucat.jpeg"))
        customView4.addSubview(customImgView)
        customImgView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 20, height: 20))
        }
        customView4.backgroundColor = UIColor.blue
//        let viewAttachment4: ICLabelAttachment = ICLabelAttachment(content: customView4,
//                                                                   contentInset: kContentInset,
//                                                                   alignment: ICAttachmentAlignment_CenterY,
//                                                                   referenceFont: UIFont.systemFont(ofSize: 20))

        let testAttr5: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        testAttr5.ic_append(viewAttachment4)
        testAttr5.append(appendAttrText)

        let icLabel5: ICLabel = ICLabel()
        icLabel5.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel5)
        icLabel5.font = UIFont.systemFont(ofSize: 20)
//        icLabel5.lineSpacing = kLineSpacing
        icLabel5.attributedText = testAttr5
        let size5: CGSize = icLabel5.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel5.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel4.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size5)
        }
    }

    private func setupExample2UI() {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "哈中test中文强势进入😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*[]~(￣▽￣)~*[]~(￣▽￣)~*ｂ╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭╮(￣▽￣)╭(￣.￣)(￣.￣)(￣.￣)(￣.￣)🀏🀏🀏🀏🀏🀡🀡🀡🀡🀡🀞🀞🀔🀊🀀速度快回复肯定会开发可来得及分类的空间烂大街法律框架爱离开对方就流口水的了肯定是解放路口就冻死了卡减肥了空间了空间大浪费空间了空间撒蝶恋蜂狂氪金大佬开房记录卡机了看见对方立刻据了解")

        let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        let kContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let kCustomViewSize: CGSize = CGSize(width: 40, height: 40)
        let kLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
        let kLabelLineSpacing: CGFloat = 0
        let maxSize: CGSize = CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude)

        let customView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        let customImgView: UIImageView = UIImageView(image: UIImage(named: "jucat.jpeg"))
        customView.backgroundColor = UIColor.blue

        customView.addSubview(customImgView)
        customImgView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.size.equalTo(kCustomViewSize)
        }

//        let viewAttachment: ICLabelAttachment = ICLabelAttachment(content: customView,
//                                                                  contentInset: kContentInset,
//                                                                  alignment: ICAttachmentAlignment_Top,
//                                                                  referenceFont: kLabelFont)
        let tempAttrText: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
        let attachmentHighlight: ICHighlight = ICHighlight()
//        attachmentHighlight.tapAction = { [weak self] in
//            guard let sSelf = self else { return }
//            let vc = UIAlertController(title: "You click attachment view", message: nil, preferredStyle: .alert)
//            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (_) in
//                vc.dismiss(animated: true, completion: nil)
//            })
//            vc.addAction(confirmAction)
//            sSelf.present(vc, animated: true, completion: nil)
//        }
//        tempAttrText.ic_insert(viewAttachment, highlight: attachmentHighlight, at: 0)

        let linkStr: String = "\(kEllipsisCharacter)全文"

        let seeMore: NSMutableAttributedString = NSMutableAttributedString(string: linkStr)

        let expendLabel: ICLabel = ICLabel()
        expendLabel.font = kLabelFont
        expendLabel.attributedText = seeMore //TODO: 考虑一下这里的这个接口设计的问题，字体、颜色竟然跟 attributedString 的设置先后有关系
        expendLabel.backgroundColor = UIColor.clear
        seeMore.ic_setFont(kLabelFont)
        seeMore.ic_setForegroundColor(UIColor.blue, range: NSRange(location: kEllipsisCharacter.count, length: linkStr.count - kEllipsisCharacter.count))
        let expendLabelSize: CGSize = expendLabel.sizeThatFits(maxSize)
        let expendLabelRect: CGRect = seeMore.boundingRect(with: maxSize,
                                                           options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                           context: nil) //不能使用该值 expendLabelRect 中的 size 字段，则会导致绘制的文字显示不出来
        
        expendLabel.frame = CGRect(origin: .zero, size: expendLabelSize)

        print("expendLabelSize: \(expendLabelSize) expendLabelRect: \(expendLabelRect)")
        let truncationToken: NSMutableAttributedString = NSMutableAttributedString()
//        truncationToken.ic_appendAttachmentContent(expendLabel,
//                                                   contentInsets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0), //这里做一下微调，因为 ICLabel 的 sizeThatFits: 函数计算出来的大小并不是 sizeThatFits 的那种，所以这里需要进行微调
//            alignment: ICAttachmentAlignment_CenterY,
//            referenceFont: expendLabel.font)

        let icLabel: ICLabel = ICLabel()
        icLabel.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel)
        icLabel.font = kLabelFont
//        icLabel.lineSpacing = kLabelLineSpacing
        icLabel.numberOfLines = 2
        icLabel.truncationToken = truncationToken
        icLabel.attributedText = tempAttrText.mutableCopy() as? NSMutableAttributedString
        let size: CGSize = icLabel.sizeThatFits(maxSize)
        icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size)
        }

//        let hightlight: ICHighlight = ICHighlight()
//        hightlight.tapAction = {
//            icLabel.numberOfLines = 0
//            let canClickLabelSize = icLabel.sizeThatFits(maxSize)
//            icLabel.snp.updateConstraints { (maker) in
//                maker.size.equalTo(canClickLabelSize)
//            }
//        }
//        seeMore.ic_setHightlight(hightlight, range: NSRange(location: kEllipsisCharacter.count, length: seeMore.length - kEllipsisCharacter.count))

        let customView2: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        let customImgView2: UIImageView = UIImageView(image: UIImage(named: "jucat.jpeg"))

        customView2.addSubview(customImgView2)
        customImgView2.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.size.equalTo(kCustomViewSize)
        }

//        let viewAttachment2: ICLabelAttachment = ICLabelAttachment(content: customView2,
//                                                                   contentInset: kContentInset,
//                                                                   alignment: ICAttachmentAlignment_CenterY,
//                                                                   referenceFont: kLabelFont)
        let tempAttrText2: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        tempAttrText2.ic_insert(viewAttachment2, at: 0)

        let icLabel2: ICLabel = ICLabel()
        icLabel2.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel2)
        icLabel2.font = kLabelFont
//        icLabel2.lineSpacing = kLabelLineSpacing
        icLabel2.attributedText = tempAttrText2.mutableCopy() as? NSMutableAttributedString
        let size2: CGSize = icLabel2.sizeThatFits(maxSize)
        icLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size2)
        }

        let customView3: UIView = UIView(frame: CGRect(x: 0, y: 0, width: kCustomViewSize.width, height: kCustomViewSize.height))
        let customImgView3: UIImageView = UIImageView(image: UIImage(named: "jucat.jpeg"))
        customView3.backgroundColor = UIColor.blue

        customView3.addSubview(customImgView3)
        customImgView3.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.size.equalTo(kCustomViewSize)
        }

//        let viewAttachment3: ICLabelAttachment = ICLabelAttachment(content: customView3, contentInset: kContentInset, alignment: ICAttachmentAlignment_Bottom, referenceFont: kLabelFont)
        let tempAttrText3: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
//        tempAttrText3.ic_insert(viewAttachment3, at: 0)

        let icLabel3: ICLabel = ICLabel()
        icLabel3.backgroundColor = UIColor.lightGray
        self.view.addSubview(icLabel3)
        icLabel3.font = kLabelFont
//        icLabel3.lineSpacing = kLabelLineSpacing
        icLabel3.attributedText = tempAttrText3.mutableCopy() as? NSMutableAttributedString
        let size3: CGSize = icLabel3.sizeThatFits(maxSize)
        icLabel3.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel2.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size3)
        }
    }

    private func setupExample3UI() {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "abg123展开可代发辽阔的积分dkd hfkjahdfjadiuyreiuhsahdkjfhkjhkfsdahsfjh")

        let kLabelInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
        let kContentInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let kFont: UIFont = UIFont.systemFont(ofSize: 15)
        let kLabelLineSpacing: CGFloat = 10

        let testAttr: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
        let image = UIImage(named: "jucat.jpeg")
//        let attachment: ICLabelAttachment = ICLabelAttachment(content: image, contentInset: kContentInset, alignment: ICAttachmentAlignment_Top, referenceFont: kFont)
//        attachment.limitSize = CGSize(width: 50, height: 50)
//
//        testAttr.ic_insert(attachment, at: 0)
        let appendAttrText: NSAttributedString = NSAttributedString(string: "--last line change")
        testAttr.append(appendAttrText.mutableCopy() as! NSMutableAttributedString)

        let icLabel: ICLabel = ICLabel()
        icLabel.backgroundColor = UIColor.lightGray
//        icLabel.lineSpacing = kLabelLineSpacing
        self.view.addSubview(icLabel)
        icLabel.attributedText = testAttr
        let size = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(100)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size)
        }

        let testAttr2: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
        let image2 = UIImage(named: "jucat.jpeg")
//        let attachment2: ICLabelAttachment = ICLabelAttachment(content: image2, contentInset: kContentInset, alignment: ICAttachmentAlignment_CenterY, referenceFont: kFont)
//        attachment2.limitSize = CGSize(width: 50, height: 50)
//
//        testAttr2.ic_insert(attachment2, at: 0)
        testAttr2.append(appendAttrText.mutableCopy() as! NSMutableAttributedString)

        let icLabel2: ICLabel = ICLabel()
        icLabel2.backgroundColor = UIColor.lightGray
//        icLabel2.lineSpacing = kLabelLineSpacing
        self.view.addSubview(icLabel2)
        icLabel2.attributedText = testAttr2
        let size2 = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel2.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size2)
        }

        let testAttr3: NSMutableAttributedString = attrText.mutableCopy() as! NSMutableAttributedString
        let image3 = UIImage(named: "jucat.jpeg")
//        let attachment3: ICLabelAttachment = ICLabelAttachment(content: image3, contentInset: kContentInset, alignment: ICAttachmentAlignment_Bottom, referenceFont: kFont)
//        attachment3.limitSize = CGSize(width: 50, height: 50)
//
//        testAttr3.ic_insert(attachment3, at: 0)
        testAttr3.append(appendAttrText.mutableCopy() as! NSMutableAttributedString)

        let icLabel3: ICLabel = ICLabel()
        icLabel3.backgroundColor = UIColor.lightGray
//        icLabel3.lineSpacing = kLabelLineSpacing
        self.view.addSubview(icLabel3)
        icLabel3.attributedText = testAttr3
        let size3 = icLabel.sizeThatFits(CGSize(width: kScreenWidth - kLabelInsets.left - kLabelInsets.right, height: CGFloat.greatestFiniteMagnitude))
        icLabel3.snp.makeConstraints { (maker) in
            maker.top.equalTo(icLabel2.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(kLabelInsets.left)
            maker.size.equalTo(size3)
        }
    }
}
