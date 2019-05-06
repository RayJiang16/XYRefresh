//
//  Ex+UIScrollView.swift
//  XYRefresh
//
//  Created by RayJiang on 2019/3/11.
//  Copyright © 2019 RayJiang. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    var inset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        }
        return contentInset
    }
    
    var insetTop: CGFloat {
        get {
            return inset.top
        } set {
            var inset = contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (adjustedContentInset.top - contentInset.top)
            }
            contentInset = inset
        }
    }
    
    var insetLeft: CGFloat {
        get {
            return inset.left
        } set {
            var inset = contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (adjustedContentInset.left - contentInset.left)
            }
            contentInset = inset
        }
    }
    
    var insetBottom: CGFloat {
        get {
            return inset.bottom
        } set {
            var inset = contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (adjustedContentInset.bottom - contentInset.bottom)
            }
            contentInset = inset
        }
    }
    
    var insetRight: CGFloat {
        get {
            return inset.right
        } set {
            var inset = contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (adjustedContentInset.right - contentInset.right)
            }
            contentInset = inset
        }
    }
    
    var offsetX: CGFloat {
        get {
            return contentOffset.x
        } set {
            contentOffset.x = newValue
        }
    }
    
    var offsetY: CGFloat {
        get {
            return contentOffset.y
        } set {
            contentOffset.y = newValue
        }
    }
    
    var contentWidth: CGFloat {
        get {
            return contentSize.width
        } set {
            contentSize.width = newValue
        }
    }
    
    var contentHeight: CGFloat {
        get {
            return contentSize.height
        } set {
            contentSize.height = newValue
        }
    }
    
}
