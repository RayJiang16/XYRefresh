//
//  RefreshNormalHeader.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/13.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

open class RefreshNormalHeader: RefreshStateHeader {
    
    public private(set) lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: BundleHelper.arrowImage)
        addSubview(view)
        return view
    }()
    
    open override func prepare() {
        super.prepare()
    }
    
    open override func placeSubviews() {
        var arrowCenterX = width * 0.5
        if !stateLabel.isHidden {
            let stateWidth = stateLabel.labelWidth
            arrowCenterX -= (stateWidth / 2) + 20
        }
        let arrowCenterY = height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if arrowImageView.constraints.isEmpty {
            arrowImageView.size = arrowImageView.image?.size ?? CGSize(width: 0, height: 0)
            arrowImageView.center = arrowCenter
        }
        arrowImageView.tintColor = stateLabel.textColor
        
        if indicator.constraints.isEmpty {
            indicator.frame = bounds
        }
        
        super.placeSubviews()
    }
    
    open override func stateChange(newState: RefreshState, oldState: RefreshState) {
        super.stateChange(newState: newState, oldState: oldState)
        
        if newState == .idle {
            if oldState == .refreshing {
                arrowImageView.transform = CGAffineTransform.identity
                
                DispatchQueue.main.asyncAfter(deadline: .now() + RefreshConst.animationDuration) {
                    self.arrowImageView.alpha = 1
                }
            } else {
                UIView.animate(withDuration: RefreshConst.animationDuration) {
                    self.arrowImageView.transform = CGAffineTransform.identity
                }
            }
        } else if newState == .pulling {
            UIView.animate(withDuration: RefreshConst.animationDuration) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0.000001 - Double.pi))
            }
        } else {
            arrowImageView.alpha = newState == .refreshing ? 0 : 1
        }
    }
    
}
