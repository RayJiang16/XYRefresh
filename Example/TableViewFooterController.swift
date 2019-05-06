//
//  TableViewFooterController.swift
//  Example
//
//  Created by RayJiang on 2019/5/6.
//  Copyright © 2019 RayJaing. All rights reserved.
//

import UIKit
import XYRefresh

final class TableViewFooterController: UITableViewController {

    public var rowType: TableViewFooterRow!
    
    private var count = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = rowType.title
        callMethod()
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.refresh.header = RefreshNormalHeader {
            self.reset()
        }
    }
    
    private func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.count = 5
            self.tableView.refresh.header?.endRefreshing()
            self.tableView.refresh.footer?.endRefreshing()
            self.tableView.reloadData()
            
            if self.rowType! == .noMoreData {
                self.tableView.refresh.footer?.resetNoMoreData()
            }
        }
    }
    
    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.count += Int((arc4random() % 5) + 3)
            self.tableView.reloadData()
            self.tableView.refresh.header?.endRefreshing()
            self.tableView.refresh.footer?.endRefreshing()
            
            if self.rowType! == .noMoreData && self.count > 15 {
                self.tableView.refresh.footer?.endRefreshingWithNoMoreData()
            }
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

extension TableViewFooterController {
    
    private func callMethod() {
        switch rowType! {
        case .default:
            method1()
        case .noMoreData:
            method2()
        case .disableAutoLoad:
            method3()
        case .gif:
            method4()
        case .customTitle:
            method5()
        case .customControl:
            method6()
        }
    }
    
    private func method1() {
        tableView.refresh.footer = RefreshAutoStateFooter {
            self.loadData()
        }
    }
    
    private func method2() {
        tableView.refresh.footer = RefreshAutoStateFooter {
            self.loadData()
        }
    }
    
    private func method3() {
        let footer = RefreshAutoStateFooter {
            self.loadData()
        }
        footer.automaticallyRefresh = false
        tableView.refresh.footer = footer
    }
    
    private func method4() {
        tableView.refresh.footer = MyGifFooter {
            self.loadData()
        }
    }
    
    private func method5() {
        let footer = RefreshAutoStateFooter {
            self.loadData()
        }
        footer.automaticallyRefresh = false
        footer.set(title: "往上拽可以加载更多数据", forState: .idle)
        footer.set(title: "松收就加载更多数据", forState: .pulling)
        tableView.refresh.footer = footer
    }
    
    private func method6() {
        tableView.refresh.footer = MyCustomFooter {
            self.loadData()
        }
    }
    
}
