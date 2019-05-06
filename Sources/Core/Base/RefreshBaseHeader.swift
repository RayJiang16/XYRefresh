//
//  RefreshBaseHeader.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/12.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

/// 负责Header基本配置
open class RefreshBaseHeader: RefreshComponent {
    
    /// 顶部忽略的数值
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0
    /// Idle -> Pulling 震动一下
    public var impactFeedbackEnabled: Bool = true
    
    private var insetTDelta: CGFloat = 0.0
    
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
        height = RefreshConst.headerHeight
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        y = -height - ignoredScrollViewContentInsetTop
    }
    
    open override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        guard let scrollView = scrollView else { return }
        
        if state == .refreshing {
            if window == nil { return }
            var insetTop = -scrollView.offsetY > scrollViewOriginalInset.top ? -scrollView.offsetY : scrollViewOriginalInset.top
            insetTop = insetTop > height + scrollViewOriginalInset.top ? height + scrollViewOriginalInset.top : insetTop
            scrollView.insetTop = insetTop
            insetTDelta = scrollViewOriginalInset.top - insetTop
            return
        }
        
        scrollViewOriginalInset = scrollView.inset
        let offsetY = scrollView.offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        if offsetY > happenOffsetY { return }
        let normalPullingOffsetY = happenOffsetY - height
        let pullingPercent = (happenOffsetY - offsetY) / height
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < normalPullingOffsetY {
                state = .pulling
            } else if state == .pulling && offsetY >= normalPullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        }
    }
    
    open override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        guard let scrollView = scrollView else { return }
        
        if oldState == .idle && newState == .pulling && impactFeedbackEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
        if newState == .idle {
            if oldState != .refreshing { return }
            UserDefaults.standard.set(Date(), forKey: RefreshConst.lastUpdatedTimeKey)
            UIView.animate(withDuration: RefreshConst.animationDuration, animations: {
                scrollView.insetTop += self.insetTDelta
                if self.automaticallyChangeAlpha {
                    self.alpha = 0.0
                }
            }) { (finished) in
                self.pullingPercent = 0.0
            }
        } else if newState == .refreshing {
            DispatchQueue.main.async {
                UIView.animate(withDuration: RefreshConst.animationDuration, animations: {
                    let top = self.scrollViewOriginalInset.top + self.height
                    scrollView.insetTop = top
                    var offset = scrollView.contentOffset
                    offset.y = -top
                    scrollView.setContentOffset(offset, animated: false)
                }, completion: { (finished) in
                    self.executeRefreshingCallback()
                })
            }
        }
    }
}
