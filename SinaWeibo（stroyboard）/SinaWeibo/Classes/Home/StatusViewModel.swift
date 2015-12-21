//
//  StatusViewModel.swift
//  SinaWeibo
//
//  Created by Minghe on 15/12/19.
//  Copyright © 2015年 Stanford swift. All rights reserved.
//

import UIKit

/*
Swift中一个类可以有父类也可以没有父类
如果一个类没有父类, 那么这个类更加轻量级, 那么他们性能会更优于有父类的

有父类和没有父类有什么区别?
1.如果想使用KVC, 那么必须继承于NSObject
2.如果想实现description属性, 那么如果没有父类必须遵守CustomStringConvertible, 如果有父类可以直接重写属性即可
*/

//class StatusViewModel: NSObject {
class StatusViewModel {
    
    // MARK: - 和Status有关的视图 ------------------------------
    /// 模型对象
    var status: Status
    /// 存储所有配图URL
    var thumbnail_pics: [NSURL]?
    
    init(status: Status) {
        self.status = status
        
        guard let urls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls else
        {
            return
        }
        
        thumbnail_pics = [NSURL]()
        
        for dict in urls
        {
            let urlStr = dict["thumbnail_pic"] as? String
            let url = NSURL(string: urlStr ?? "")!
            thumbnail_pics?.append(url)
        }
    }
    
    /// 来源字符串
    var sourceText: String
        {
            // 1.安全校验
            guard let temp = status.source where temp != "" else {
                return ""
            }
            // 2.找到开始位置
            let startIndex = (temp as NSString).rangeOfString(">").location + 1
            // 3.找到需要截取的字符串的长度
            let length = (temp as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            // 4.截取字符串
            let res = (temp as NSString).substringWithRange(NSMakeRange(startIndex, length))
            
            return "来自 " + res
            }
    
    
    var createdText: String {
        //        created_at = "Tue May 31 17:46:55 +0800 2011"
        /*
        0.安全校验
        先检查created_at是否有值，如果没有就进入else
        并且temp不能是 "", 如果是""就进入else
        */
        guard let temp = status.created_at where temp != "" else {
            return ""
        }
        
        // 1.将发布微博的时间字符串转换为NSDate
        guard let createdDate = NSDate.dataWithString(temp) else {
            return ""
        }
        
        // 2.利用
        return createdDate.desc
        
    }
    
    
    // MARK: - 和User有关的视图 ------------------------------
    /// 认证图片
    var verifiedImage: UIImage?
        {
            switch status.user?.verified_type ?? -1 {
            case 0:
                // 个人认证
                return UIImage(named: "avatar_vip")
            case 2, 3, 5:
                // 企业认证
                return UIImage(named: "avatar_enterprise_vip")
            case 220:
                // 微博达人
                return UIImage(named: "avatar_grassroot")
            default:
                // 没有认证
                return nil
            }
    }
    
    /// 会员图片
    var mbrankImage: UIImage?
        {
            if status.user?.mbrank >= 1 && status.user?.mbrank <= 6
            {
                return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
            }
            return nil
    }
    
    /// 用户头像URL
    var avatarURL: NSURL?
        {
            return NSURL(string: status.user?.profile_image_url ?? "")
    }


    
    }
