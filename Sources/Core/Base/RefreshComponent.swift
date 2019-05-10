//
//  RefreshComponent.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/11.
//  Copyright © 2019 RayJiang. All rights reserved.
//  GitHub: https://github.com/RayJiang16/XYRefresh

import UIKit

public typealias refreshingCallback = (() -> Void)

public protocol RefreshComponentDelegate: class {
    func refreshing(component: RefreshComponent)
}

open class RefreshComponent: UIView {
    
    public var state: RefreshState {
        get {
            return _state
        }
        set {
            if _state != newValue {
                stateChange(newState: newValue, oldState: _state)
                _state = newValue
                DispatchQueue.main.async {
                    self.setNeedsLayout()
                }
            }
        }
    }
    
    /// 自动修改透明度
    public var automaticallyChangeAlpha: Bool = false
    public var scrollViewOriginalInset: UIEdgeInsets = .zero
    public var isRefreshing: Bool { return state == .refreshing || state == .willRefresh }
    public var pullingPercent: CGFloat = 0.0 {
        didSet {
            if isRefreshing { return }
            if automaticallyChangeAlpha {
                alpha = pullingPercent
            }
        }
    }
    
    
    public var refreshingCallback: refreshingCallback? = nil
    public var delegate: RefreshComponentDelegate? = nil
    
    public weak var scrollView: UIScrollView? = nil
    private var pan: UIPanGestureRecognizer? = nil
    private var _state: RefreshState = .idle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil { return }
        guard let newSuperview = newSuperview as? UIScrollView else {
            fatalError("Superview must be UIScrollView")
        }
        scrollView = newSuperview
        removeObservers()
        width = newSuperview.width
        x = -newSuperview.insetLeft
        newSuperview.alwaysBounceVertical = true
        scrollViewOriginalInset = newSuperview.inset
        addObservers()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .willRefresh {
            state = .refreshing
        }
    }
    
    // MARK: - KVC
    private func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: "state", options: options, context: nil)
    }
    
    private func removeObservers() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        superview?.removeObserver(self, forKeyPath: "contentSize")
        pan?.removeObserver(self, forKeyPath: "state")
        pan = nil
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 遇到这些情况就直接返回
        if !isUserInteractionEnabled { return }
        
        // 这个就算看不见也需要处理
        if keyPath == "contentSize" {
            scrollViewContentSizeDidChange(change: change)
        }
        
        // 看不见
        if isHidden { return }
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == "state" {
            scrollViewPanStateDidChange(change: change)
        }
    }
    
    /// 回调
    open func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.refreshingCallback?()
            strongSelf.delegate?.refreshing(component: strongSelf)
        }
    }
    
    // MARK: - 子类重写
    open func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }
    
    open func stateChange(newState: RefreshState, oldState: RefreshState) {
        DispatchQueue.main.async {
            self.setNeedsLayout()
        }
    }
    
    open func placeSubviews() { }
    open func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) { }
    open func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) { }
    open func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) { }
    
    /// 开始刷新
    open func beginRefreshing() {
        pullingPercent = 1.0
        if window != nil {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .willRefresh
                setNeedsDisplay()
            }
        }
    }
    
    /// 结束刷新
    open func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
}
