//
//  QRCodeViewController.swift
//  SinaWeibo
//
//  Created by Minghe on 11/11/15.
//  Copyright © 2015 Stanford swift. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    /// 显示扫描结果
    @IBOutlet weak var textLabel: UILabel!
    /// 冲击波
    @IBOutlet weak var scanLine: UIImageView!
    /// 容器视图高度
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 容器视图
    @IBOutlet weak var containerView: UIView!
    /// 冲击波的顶部约束
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    /// UITabBar
    @IBOutlet weak var customTabbar: UITabBar!
    
    /// 定义变量用来判断是否要继续扫描
    var isScan = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.设置tabbar默认选中
        customTabbar.selectedItem = customTabbar.items![0]
        customTabbar.delegate = self
        // 2.执行冲击波动画
        startAnimation()
        // 3.开始扫描
        startScan()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if isScan {
        // 2.执行冲击波动画
        startAnimation()
        // 3.开始扫描
        startScan()
        }
        
    }
    
    // MARK: - 懒加载 ------------------------------
    /// 创建输入
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let deviceInput = try? AVCaptureDeviceInput(device: device)
        return deviceInput
        
    }()
    
    /// 创建输出
    private lazy var output: AVCaptureMetadataOutput = {
       let out = AVCaptureMetadataOutput()
        
        // 1.屏幕的frame
        let rect = self.view.frame
        // 2.容器视图的frame
        let containerRect = self.containerView.frame
        
        // 注意: 该属性接收的不是坐标, 而是比例
        // 注意: 该属性并不是以竖屏的左上角作为参照, 而是以横屏的左上角作为参照
        // 所以计算时, x就变成了y, y就变成了x, width就变成了height, height就变成了width
        out.rectOfInterest = CGRect(x: containerRect.origin.y / rect.size.height, y: containerRect.origin.x / rect.size.width, width: containerRect.size.height / rect.size.height, height: containerRect.size.width / rect.size.width)
        
        return out
    }()
    
    /// 创建会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    /// 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
       let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = self.view.bounds
        return layer
    }()
    
    /// 创建保存二维码边线的图层
    private lazy var drwaLayer: CALayer = {
       let layer = CALayer()
        layer.frame = self.view.bounds
        return layer
    }()
    
    
    // MARK: - 内部控制方法 ------------------------------
    /// 关闭扫描二维码页面
    @IBAction func cancelClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 从相册中选择图片扫描
    @IBAction func albumClick(sender: UIBarButtonItem) {
        
        // 0.判断是否可以打开相册
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) else {
            return
        }
        
        // 1.创建图片选择器
        let pickerVc = UIImagePickerController()
        pickerVc.delegate = self
        
        // 2.弹出图片选择器
        presentViewController(pickerVc, animated: true, completion: nil)
        
    }
    
    /// 冲击波动画
    private func startAnimation()
    {
        // 1.1 让冲击波初始化到容器视图的顶部
        scanLineTopCons.constant = -self.containerHeightCons.constant + 10
        view.layoutIfNeeded()
        
        // 1.2 重复执行扫描动画
        UIView.animateWithDuration(1.5) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 冲击波到容器视图的底部
            self.scanLineTopCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }
    }
    
    /// 开始扫描二维码
    private func startScan()
    {
        // 1. 判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        
        // 2. 判断输出能否添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        
        // 3. 添加输入和输出
        session.addInput(input)
        session.addOutput(output)
        
        // 4. 告诉系统输出可以解析的数据类型
        // 注意：设置可以解析数据类型一定要在输出对象添加到会话之后设置，否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5. 设置代理监听解析结果
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 6. 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        // 6.1 添加画线图层
        view.layer.insertSublayer(drwaLayer, above: previewLayer)
        
        // 7. 开始扫描
        session.startRunning()
        
        
    }
}


extension QRCodeViewController: UITabBarDelegate
{
    /// 通过代理方法，切换扫描框的大小
    // 二维码的扫描框是正方形，条形码的扫描框是长条形
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // 1.修改容器视图的高度
        containerHeightCons.constant = (item.tag == 0) ? 200 : 100
        view.layoutIfNeeded()
        
        scanLine.layer.removeAllAnimations()
        
        startAnimation()
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    /// AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // ?? 的含义：如果前面的值是nil,那么就返回后面的值，如果前面不是nil,后面不执行
        textLabel.text = metadataObjects.last?.stringValue ?? "将条形码／二维码放入框中即可扫描"
        
        
        clearLines()
        
        // 1.遍历结果集
        for objc in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // 2.将结果集中的对象保存的corners坐标，转为我们能识别的坐标
            let res = previewLayer.transformedMetadataObjectForMetadataObject(objc)
            // 3.绘制二维码边线
            drawLines(res as! AVMetadataMachineReadableCodeObject)
        }
    }
    
    
    // MARK: - 绘制二维码边线 ------------------------------
    /// 绘制二维码边线
    private func drawLines(cornersObjc: AVMetadataMachineReadableCodeObject)
    {
        // 0.进行安全校验
        guard let corners = cornersObjc.corners else {
            MHzLog("no data")
            return
        }
        
        // 1.创建CAShapeLayer 
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.greenColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 4
        
        // 2. 创建路径
        let path = UIBezierPath()
        // 定义变量保存从corners取出来的结果
        var point: CGPoint = CGPointZero
        // 定义变量保存索引
        var index = 0
        
        // 2.1移动到起点
        CGPointMakeWithDictionaryRepresentation((corners[index++] as! CFDictionary), &point)
        path.moveToPoint(point)
        
        // 2.2链接其他的点
        while index < corners.count
        {
            CGPointMakeWithDictionaryRepresentation((corners[index++] as! CFDictionary), &point)
            path.addLineToPoint(point)
        }
        path.closePath()
        
        shapeLayer.path = path.CGPath
        
        // 3.将绘制好的图层添加到drwaLayer
        drwaLayer.addSublayer(shapeLayer)
    }
    
    /// 清空二维码边线
    private func clearLines() {
        // 1.检查有没有子图层
        guard let subLayers = drwaLayer.sublayers else
        {
            MHzLog("No sublayers")
            return
        }
        
        // 2.删除子图层
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}

extension QRCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 只要选中一张图片，就会调用这个方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1.取出当前选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            MHzLog("no choose photo")
            return
        }
        
        // 2.从图片中识别二维码数据
        // 2.1创建一个CIImage
        let ciImage = CIImage(image: image)!
        
        // 2.2创建一个探测器
        let dict = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: dict)
        
        // 2.3利用探测器检测结果
        let features = detector.featuresInImage(ciImage)
        
        for objc in features
        {
            textLabel.text = (objc as! CIQRCodeFeature).messageString
        }
        
        // 3.关闭图片选择器
        isScan = false
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}















