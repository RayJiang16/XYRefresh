//
//  RefreshGifHeader.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/14.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

open class RefreshGifHeader: RefreshBaseHeader {
    
    public private(set) lazy var gifView: UIImageView = {
        let view = UIImageView()
        addSubview(view)
        return view
    }()
    
    /// 缩放 0.7-1.0
    public var automaticallyScale = false
    
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
        
        if newState == .pulling || newState == .refreshing {
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
            gifView.stopAnimating()
        }
    }
    
    public override var pullingPercent: CGFloat {
        didSet {
            let images = stateImages[.idle] ?? []
            if state != .idle || images.isEmpty { return }
            gifView.stopAnimating()
            var index = Int(CGFloat(images.count) * pullingPercent)
            if index >= images.count {
                index = images.count-1
            }
            gifView.image = images[index]
            
            if automaticallyScale {
                var offset = 0.7 + 0.3 * pullingPercent
                offset = offset > 1 ? 1 : offset
                gifView.transform = CGAffineTransform(scaleX: offset, y: offset)
            }
        }
    }
}

// MARK: - 公开方法
extension RefreshGifHeader {
    
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
