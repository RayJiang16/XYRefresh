//
//  Example.swift
//  Example
//
//  Created by RayJiang on 2019/5/5.
//  Copyright © 2019 RayJaing. All rights reserved.
//

import UIKit

public enum Section {
    case tableViewHeader([TableViewHeaderRow])
    case tableviewFooter([TableViewFooterRow])
    
    var title: String {
        switch self {
        case .tableViewHeader(_):
            return "UITableView + 下拉刷新"
        case .tableviewFooter(_):
            return "UITableView + 上拉加载"
        }
    }
    
    static var allCase: [Section] {
        return [.tableViewHeader(TableViewHeaderRow.allCases),
                .tableviewFooter(TableViewFooterRow.allCases)]
    }
}

public enum TableViewHeaderRow: CaseIterable {
    case `default`
    case hasArrow
    case autoHide
    case gif
    case gifAutoScale
    case customTitle
    case customControl
    
    var title: String {
        switch self {
        case .default:
            return "默认"
        case .hasArrow:
            return "有箭头"
        case .autoHide:
            return "渐变"
        case .gif:
            return "Gif"
        case .gifAutoScale:
            return "Gif 自动拉伸"
        case .customTitle:
            return "自定义文字"
        case .customControl:
            return "自定义控件"
        }
    }
}

public enum TableViewFooterRow: CaseIterable {
    case `default`
    case noMoreData
    case disableAutoLoad
    case gif
    case customTitle
    case customControl
    
    var title: String {
        switch self {
        case .default:
            return "默认"
        case .noMoreData:
            return "全部加载完成"
        case .disableAutoLoad:
            return "禁止自动加载"
        case .gif:
            return "Gif"
        case .customTitle:
            return "自定义文字"
        case .customControl:
            return "自定义控件"
        }
    }
}
