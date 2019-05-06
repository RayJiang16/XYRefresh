//
//  MyCustomHeader.swift
//  Example
//
//  Created by RayJiang on 2019/5/6.
//  Copyright © 2019 RayJaing. All rights reserved.
//

import UIKit
import XYRefresh

final class MyCustomHeader: RefreshBaseHeader {

    private(set) lazy var stateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.text = "下拉刷新~"
        addSubview(view)
        return view
    }()
    
    private(set) lazy var mySwitch: UISwitch = {
        let view = UISwitch()
        addSubview(view)
        return view
    }()
    
    /// 布局
    override func placeSubviews() {
        super.placeSubviews()
        
        stateLabel.frame = bounds
        mySwitch.frame = CGRect(x: 10, y: 10, width: 49, height: 31)
    }
    
    /// 状态变化
    override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        
        switch newState {
        case .idle:
            stateLabel.text = "下拉刷新~"
            mySwitch.setOn(false, animated: true)
        case .pulling:
            stateLabel.text = "松开刷新~"
            mySwitch.setOn(true, animated: true)
        case .refreshing:
            stateLabel.text = "正在刷新..."
            mySwitch.setOn(true, animated: true)
        default:
            break
        }
    }
}
