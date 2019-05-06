//
//  TableViewHeaderController.swift
//  Example
//
//  Created by RayJiang on 2019/5/5.
//  Copyright © 2019 RayJaing. All rights reserved.
//

import UIKit
import XYRefresh

class TableViewHeaderController: UITableViewController {

    public var rowType: TableViewHeaderRow!
    
    private var count = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = rowType.title
        callMethod()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.count += Int((arc4random() % 5) + 3)
            self.tableView.refresh.header?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension TableViewHeaderController {
    
    private func callMethod() {
        switch rowType! {
        case .default:
            method1()
        case .hasArrow:
            method2()
        case .autoHide:
            method3()
        case .gif:
            method4()
        case .gifAutoScale:
            method5()
        case .customTitle:
            method6()
        case .customControl:
            method7()
        }
    }
    
    private func method1() {
        tableView.refresh.header = RefreshStateHeader {
            self.loadData()
        }
    }
    
    private func method2() {
        tableView.refresh.header = RefreshNormalHeader {
            self.loadData()
        }
    }
    
    private func method3() {
        let header = RefreshNormalHeader {
            self.loadData()
        }
        header.automaticallyChangeAlpha = true
        tableView.refresh.header = header
    }
    
    private func method4() {
        let header = MyGifHeader {
            self.loadData()
        }
        tableView.refresh.header = header
    }
    
    private func method5() {
        let header = MyGifHeader {
            self.loadData()
        }
        header.automaticallyScale = true
        tableView.refresh.header = header
    }
    
    private func method6() {
        let header = RefreshNormalHeader {
            self.loadData()
        }
        header.set(title: "下拉刷新喔", forState: .idle)
        header.set(title: "松手可以刷新哟", forState: .pulling)
        tableView.refresh.header = header
    }
    
    private func method7() {
        tableView.refresh.header = MyCustomHeader {
            self.loadData()
        }
    }
    
}
