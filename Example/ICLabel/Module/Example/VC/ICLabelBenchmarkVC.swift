//
//  ICLabelBenchmarkVC.swift
//  iOSExample
//
//  Created by iCrany on 2018/10/11.
//  Copyright © 2018 iCrany. All rights reserved.
//

import Foundation
import UIKit
import ICLabel

//swiftlint:disable force_cast
class ICLabelBenchmarkVC: UIViewController {

    private lazy var dataList: [String] = {
        var list: [String] = []
        for i in 0..<1000 {
            list.append("\(i)-new-😁😁😁😁😁😁😀😀😀😀😀🧀🧀🧀🧀🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🥔🍑🍑🍑🍎🍎🍎🍎🍎🍏🍏🍏🍏🍏（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗（￣︶￣）↗[]~(￣▽￣)~*")
        }
        return list
    }()

    private lazy var tableView: UITableView = {
        let v = UITableView(frame: .zero, style: .plain)
        v.delegate = self
        v.dataSource = self
        v.register(ICBenchMarkCell.self, forCellReuseIdentifier: "ICBenchMarkCell")
        return v
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupUI()
    }

    private func setupUI() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(84)
            maker.left.right.bottom.equalToSuperview()
        }
    }
}

extension ICLabelBenchmarkVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str = self.dataList[indexPath.row]
        let cell: ICBenchMarkCell = tableView.dequeueReusableCell(withIdentifier: "ICBenchMarkCell") as! ICBenchMarkCell
        cell.update(str: str)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let str = self.dataList[indexPath.row]
        return ICBenchMarkCell.getCellSize(str: str).height
    }
}
