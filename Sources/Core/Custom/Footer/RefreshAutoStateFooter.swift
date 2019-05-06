//
//  RefreshAutoStateFooter.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/4/25.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

open class RefreshAutoStateFooter: RefreshBaseFooter {

    public private(set) lazy var stateLabel: UILabel = {
        let view = UILabel.refreshLabel()
        addSubview(view)
        return view
    }()
    
    public private(set) lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.alpha = 0
        addSubview(view)
        return view
    }()
    
    private var stateTitles:[RefreshState:String] = [:]
    
    open override func prepare() {
        super.prepare()
        
        set(title: BundleHelper.localizedString(key: RefreshConst.footerIdleText), forState: .idle)
        set(title: BundleHelper.localizedString(key: RefreshConst.footerPullingText), forState: .pulling)
        set(title: BundleHelper.localizedString(key: RefreshConst.footerNoMoreDataText), forState: .noMoreData)
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        if indicator.constraints.isEmpty {
            indicator.frame = bounds
        }
        if stateLabel.constraints.isEmpty {
            stateLabel.frame = bounds
        }
    }
    
    open override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        
        stateLabel.text = stateTitles[newState]
        if newState == .idle && oldState == .refreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + RefreshConst.animationDuration) {
                self.indicator.alpha  = 0
                self.stateLabel.alpha = 1
                self.indicator.stopAnimating()
            }
        } else {
            indicator.alpha  = newState == .refreshing ? 1 : 0
            stateLabel.alpha = newState == .refreshing ? 0 : 1
        }
        if newState == .refreshing {
            indicator.startAnimating()
        }
    }
}

// MARK: - 公有方法
extension RefreshAutoStateFooter {
    /// 设置不同状态下文本内容  可自定义
    public func set(title: String, forState: RefreshState) {
        if title.isEmpty { return }
        stateTitles[forState] = title
        stateLabel.text = stateTitles[state]
    }
}
