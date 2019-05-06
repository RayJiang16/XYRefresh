//
//  ViewController.swift
//  Example
//
//  Created by RayJiang on 2019/5/6.
//  Copyright © 2019 RayJiang. All rights reserved.
//  GitHub: https://github.com/RayJiang16/XYRefresh

import UIKit
import XYRefresh

final class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Refresh"
        setupView()
    }
    
    private func setupView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCase.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section.allCase[section] {
        case .tableViewHeader(let rowTypes):
            return rowTypes.count
        case .tableviewFooter(let rowTypes):
            return rowTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch Section.allCase[indexPath.section] {
        case .tableViewHeader(let rowTypes):
            let rowType = rowTypes[indexPath.row]
            cell.textLabel?.text = rowType.title
        case .tableviewFooter(let rowTypes):
            let rowType = rowTypes[indexPath.row]
            cell.textLabel?.text = rowType.title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCase[section].title
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller: UIViewController
        let section = Section.allCase[indexPath.section]
        switch section {
        case .tableViewHeader(let rowTypes):
            let vc = TableViewHeaderController(style: .plain)
            vc.rowType = rowTypes[indexPath.row]
            controller = vc
        case .tableviewFooter(let rowTypes):
            let vc = TableViewFooterController(style: .plain)
            vc.rowType = rowTypes[indexPath.row]
            controller = vc
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

