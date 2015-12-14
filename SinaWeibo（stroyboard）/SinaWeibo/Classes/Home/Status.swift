//
//  Status.swift
//  SinaWeibo
//
//  Created by Minghe on 15/11/14.
//  Copyright © 2015年 Stanford swift. All rights reserved.
//

import UIKit

class Status: NSObject {

    // MARK: - 发布日期 ------------------------------
    /// 当前这条微博的发布时间 "Tue May 31 17:46:55 +0800 2011"
    var created_at: String?
    var createdText: String {
//        created_at = "Tue May 31 17:46:55 +0800 2011"
        /*
        0.安全校验
        先检查created_at是否有值，如果没有就进入else
        并且temp不能是 "", 如果是""就进入else
        */
        guard let temp = created_at where temp != "" else {
            return ""
        }
        
        // 1.将发布微博的时间字符串转换为NSDate
        guard let createdDate = NSDate.dataWithString(temp) else {
            return ""
        }
        
        // 2.利用
        return createdDate.desc
        
            }
    
    // MARK: - 来源 ------------------------------
    /// 来源字符串
    var sourceText: String = ""
    /// 来源 <a href=\"http://app.weibo.com/t/feed/2O2xZO\" rel=\"nofollow\">人民网微博</a>
    var source: String?
        {
        didSet{
            // 1.安全校验
            guard let temp = source where temp != "" else {
                return
            }
            // 2.找到开始位置
            let startIndex = (temp as NSString).rangeOfString(">").location + 1
            // 3.找到需要截取的字符串的长度
            let length = (temp as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            // 4.截取字符串
            let res = (temp as NSString).substringWithRange(NSMakeRange(startIndex, length))
            
            sourceText = "来自 " + res
            
        }
    }
    
    // MARK: - 其它实例变量 ------------------------------
    /// 字符串型的微博ID
    var idstr: String?
    /// 微博信息内容
    var text: String?
    /// 当前微博对应的用户
    var user: User?
    /// 存储所有配图
    var pic_urls: [[String: AnyObject]]?
    
    // MARK: - 方法 ------------------------------
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // KVC的setValueForKeysWithDictionary方法内部会调用下面这个方法
    override func setValue(value: AnyObject?, forKey key: String) {

        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return // 如果自己处理了，那么就不需要父类处理了，所以要return掉
        }
        super.setValue(value, forKey: key)
    }

    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at","source","idstr","text"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
