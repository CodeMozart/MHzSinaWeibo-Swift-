//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by Minghe on 11/6/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // 1.设置全局外观
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        // 2.注册通知，监听根控制器的改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("switchRootViewController:"), name: MHzRootViewControllerChanged, object: nil)
        
        // 3.创建keywindow
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()

        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    

}

extension AppDelegate {
    
    /// 切换根控制器
    @objc private func switchRootViewController(notify: NSNotification)
    {

        if let _ = notify.userInfo {
            // 切换到欢迎界面
            window?.rootViewController = createViewController("WelcomeViewController")
            return
        }
        
        // 切换到首页
        window?.rootViewController = createViewController("Main")
    }
    
    
    /// 根据一个sb名称创建一个控制器
    private func createViewController(viewController: String) -> UIViewController {
        let sb = UIStoryboard(name: viewController, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
    
    /// 返回默认控制器
    private func defaultViewController() -> UIViewController {
        
        if let _ = UserAccount.loadUserAccount()
        {
            return isNewVersion() ? createViewController("NewFeatureViewController") : createViewController("WelcomeViewController")
        }
        
        return createViewController("Main")
    }
    
    /// 判断是否有新版本
    private func isNewVersion() -> Bool
    {
        // 1.从info.plist文件中获取当前软件的版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // 2.从沙盒中获取以前软件的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sandboxVersion = (userDefaults.objectForKey("CFBundleShortVersionString") as? String) ?? "0.0"
        
        // 3.比较当前版本号和以前版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 当前 > 沙盒 -> 有新版本
            /// 4.存储当前的软件版本号到沙盒中
            userDefaults.setObject(currentVersion, forKey: "CFBundleShortVersionString")
            userDefaults.synchronize() // iOS7以前要这样做，iOS7以后不需要
            return true
            
        }
        
        // 5.返回结果 true false
        return false
    }
    
}

/*
自定义LOG的目的:
在开发阶段自动显示LOG
在发布阶段自动屏蔽LOG

print(__FUNCTION__)  // 打印所在的方法
print(__LINE__)     // 打印所在的行
print(__FILE__)     // 打印所在文件的路径

方法名称[行数]: 输出内容
*/

func MHzLog<T>(message: T, method: String = __FUNCTION__, line: Int = __LINE__)
{
    #if DEBUG
    print("\(method)[\(line)]:\(message)")
    #endif
}
































