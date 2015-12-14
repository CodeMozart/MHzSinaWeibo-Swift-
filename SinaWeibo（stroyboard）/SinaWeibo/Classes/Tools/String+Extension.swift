//
//  String+Extension.swift
//  SinaWeibo
//
//  Created by Minghe on 11/11/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

extension String
{
    /// 快速返回一个文档目录路径
    func docDir() -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        
        return (docPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 快速返回一个缓存目录路径
    func cacheDir() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        
        return (cachePath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 快速返回一个临时目录路径
    func tempDir() -> String {

        let tempPath = NSTemporaryDirectory()
        
        return (tempPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
}
