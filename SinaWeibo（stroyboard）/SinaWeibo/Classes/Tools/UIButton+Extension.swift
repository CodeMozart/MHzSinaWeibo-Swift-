//
//  UIButton+Extension.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

extension UIButton
{
//    // func == OC -
//    // class func == OC +

    convenience init(imageName: String?, backgroundImage: String)
    {
        self.init()
        
        setBackgroundImage(UIImage(named: backgroundImage), forState: .Normal)
        setBackgroundImage(UIImage(named: backgroundImage + "_highlighted"), forState: .Highlighted)
        sizeToFit()
        
        guard let name = imageName else {
            return
        }
        
        setImage(UIImage(named: name), forState: .Normal)
        setImage(UIImage(named: name + "_highlighted"), forState: .Highlighted)
        sizeToFit()
    
    }
    
    /// 根据背景图片创建按钮
    convenience init(backgroundImage: String) {
        
        self.init(imageName:nil, backgroundImage: backgroundImage)
    }
}
