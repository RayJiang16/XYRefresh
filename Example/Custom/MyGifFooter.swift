//
//  MyGifFooter.swift
//  Example
//
//  Created by RayJiang on 2019/5/6.
//  Copyright © 2019 RayJaing. All rights reserved.
//

import UIKit
import XYRefresh

final class MyGifFooter: RefreshAutoGifFooter {

    override func prepare() {
        super.prepare()
        
        var images = [UIImage]()
        for index in 1...4 {
            if let image = UIImage(named: "Gif0\(index)") {
                images.append(image)
            }
        }
        
        set(images: images, forState: .pulling)
        set(images: images, forState: .refreshing)
    }

}
