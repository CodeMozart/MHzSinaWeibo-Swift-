//
//  TitleButton.swift
//  SinaWeibo
//
//  Created by Minghe on 11/9/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    /// 通过代码创建时会调用
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 点击时不允许高亮
        adjustsImageWhenHighlighted = false
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        
        
    }
    
    /// 通过SB/XIB创建时调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 默认情况下，按钮的文字在左，图片在右；通过调整，让图片在左，文字在右
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
        
        sizeToFit()
    }

}
