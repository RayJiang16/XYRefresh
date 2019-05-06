//
//  RefreshAutoGifFooter.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/4/26.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

open class RefreshAutoGifFooter: RefreshAutoStateFooter {

    public private(set) lazy var gifView: UIImageView = {
        let view = UIImageView()
        addSubview(view)
        return view
    }()
    
    private var stateImages: [RefreshState:[UIImage]] = [:]
    private var stateDurations: [RefreshState:TimeInterval] = [:]
    
    open override func prepare() {
        super.prepare()
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        
        if !gifView.constraints.isEmpty { return }
        gifView.frame = bounds
        gifView.contentMode = .center
    }

    open override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        
        if oldState == .refreshing && newState == .idle {
            DispatchQueue.main.asyncAfter(deadline: .now() + RefreshConst.animationDuration) {
                self.stateLabel.alpha = 1
                self.gifView.stopAnimating()
            }
            return
        }
        if newState == .pulling || newState == .refreshing {
            indicator.isHidden = true
            stateLabel.alpha = 0
            
            let images = stateImages[newState] ?? []
            if images.isEmpty { return }
            
            gifView.stopAnimating()
            if images.count == 1 {
                gifView.image = images.first
            } else {
                gifView.animationImages = images
                gifView.animationDuration = stateDurations[newState] ?? Double(images.count) * 0.1
                gifView.startAnimating()
            }
        } else if newState == .idle {
            stateLabel.alpha = 1
            gifView.stopAnimating()
        }
    }
    
}

// MARK: - 公开方法
extension RefreshAutoGifFooter {
    
    public func set(images: [UIImage], duration: TimeInterval, forState state: RefreshState) {
        if images.isEmpty { return }
        
        stateImages[state] = images
        stateDurations[state] = duration
        if let image = images.first, image.size.height > height {
            height = image.size.height
        }
    }
    
    public func set(images: [UIImage], forState state: RefreshState) {
        set(images: images, duration: Double(images.count) * 0.1, forState: state)
    }
    
}
