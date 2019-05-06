//
//  RefreshBaseFooter.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/4/25.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

/// 负责Footer基本配置
open class RefreshBaseFooter: RefreshComponent {

    /// 底部忽略的数值
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    /// 自动刷新
    public var automaticallyRefresh: Bool = true
    /// 底部控件出现多少自动刷新
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    /// 是否正在滑动
    private var beginPan: Bool = false
    
    public init() {
        super.init(frame: .zero)
    }
    
    public convenience init(_ refreshingCallback: @escaping refreshingCallback) {
        self.init()
        self.refreshingCallback = refreshingCallback
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func prepare() {
        super.prepare()
        height = RefreshConst.footerHeight
    }
    
    /// 结束刷新并将状态设置为NoMoreData
    open func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }
    
    /// 将状态改为Idle
    open func resetNoMoreData() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil {
            if !isHidden {
                scrollView?.insetBottom += height
            }
            if let contentHight = scrollView?.contentHeight {
                y = contentHight
            }
        } else {
            if !isHidden {
                scrollView?.insetBottom -= height
            }
        }
    }
    
    open override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        if let contentHight = scrollView?.contentHeight {
            y = contentHight
        }
    }
    
    open override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        guard let scrollView = scrollView else { return }
        
        if scrollView.insetTop + scrollView.offsetY <= 0 {
            return
        }
        if (state != .idle && state != .pulling) { return }
        
        let num = scrollView.contentHeight - scrollView.height + height * triggerAutomaticallyRefreshPercent + scrollView.insetBottom - height
        if (scrollView.offsetY >= num) {
            let old = change?[.oldKey] as? CGPoint
            let new = change?[.newKey] as? CGPoint
            if (new?.y ?? 0) <= (old?.y ?? 0) { return }
            if automaticallyRefresh {
                beginRefreshing()
            } else {
                if beginPan {
                    state = .pulling
                }
            }
        } else {
            if scrollView.insetTop + scrollView.contentHeight > scrollView.height {
                state = .idle
            }
        }
        
    }
    
    open override func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change: change)
        if (state != .idle && state != .pulling) { return }
        
        guard let panState = scrollView?.panGestureRecognizer.state else { return }
        guard let scrollView = scrollView else { return }
        switch panState {
        case .began:
            beginPan = true
        case .ended:
            beginPan = false
            if state == .pulling {
                beginRefreshing()
            } else if scrollView.insetTop + scrollView.contentHeight <= scrollView.height { // 不够一个屏幕
                if scrollView.offsetY >= -scrollView.insetTop { // 向上拽
                    beginRefreshing()
                }
            } else { // 超出一个屏幕
                if scrollView.offsetY >= scrollView.contentHeight + scrollView.insetBottom - scrollView.height {
                    beginRefreshing()
                } else {
                    state = .idle
                }
            }
        default:
            break
        }
    }
    
    open override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        
        switch newState {
        case .refreshing:
            executeRefreshingCallback()
        default:
            break
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            if !oldValue && isHidden {
                state = .idle
                scrollView?.insetBottom -= height
            } else if oldValue && !isHidden {
                scrollView?.insetBottom += height
                if let contentHeight = scrollView?.contentHeight {
                    y = contentHeight
                }
            }
        }
    }
}
