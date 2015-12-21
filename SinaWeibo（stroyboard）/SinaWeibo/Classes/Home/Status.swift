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
    // MARK: - 来源 ------------------------------
    /// 来源 <a href=\"http://app.weibo.com/t/feed/2O2xZO\" rel=\"nofollow\">人民网微博</a>
    var source: String?
    // MARK: - 其它实例变量 ------------------------------
    /// 字符串型的微博ID
    var idstr: String?
    /// 微博信息内容
    var text: String?
    /// 当前微博对应的用户
    var user: User?
    /// 存储所有配图字典
    var pic_urls: [[String: AnyObject]]?
    /// 转发微博
    var retweeted_status: Status?

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
        
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String: AnyObject])
            return
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
