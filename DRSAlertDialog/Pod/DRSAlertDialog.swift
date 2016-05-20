//
//  DRSAlertDialog.swift
//  DRSAlertDialog
//
//  Created by Xiaoqiang Zhang on 16/3/2.
//  Copyright © 2016年 Xiaoqiang Zhang. All rights reserved.
//

import UIKit

let AlertWidth:CGFloat   = 270
let AlertHeight:CGFloat  = 130

let AlertPadding:CGFloat = 10
let MenuHeight:CGFloat   = 44

enum ButtonType {
  case Button_OK, Button_CANCEL, Button_OTHER
}

class DRSAlertDialogItem: NSObject {
  var title:String?
  var type:ButtonType?
  var tag:NSInteger?
  var action:((item:DRSAlertDialogItem) -> Void)?
}

//typealias te = (item:DRSAlertDialogItem) -> Void)

class DRSAlertDialog: UIView {

  var coverView:UIView?
  var alertView:UIView?
  var labelTitle:UILabel?
  var labelmessage:UILabel?
  
  var buttonScrollView:UIScrollView?
  var contentScrollView:UIScrollView?
  
  var items:NSMutableArray?
  var title:String?
  var message:String?
  
  var buttonWidth:CGFloat?
  var contentView:UIView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  // 便利构造函数
  convenience init(title:String, message:String, messageColor:UIColor?) {
    
    // 计算frame
    var screenWidth  = UIScreen.mainScreen().bounds.size.width
    var screenHeight = UIScreen.mainScreen().bounds.size.height
    // On iOS7, screen width and height doesn't automatically follow orientation
    if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 {
      let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
      if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
        let tmp = screenWidth
        screenWidth = screenHeight
        screenHeight = tmp
      }
    }
    let rect = CGRectMake(0, 0, screenWidth, screenHeight)
    
    self.init(frame: rect)
    self.items = NSMutableArray()
    self.title = title
    self.message = message
    
    // 设置views
    self.buildViews(messageColor)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  
  func buildViews(color:UIColor?) {
    self.coverView = UIView(frame: self.topView().bounds)
    self.coverView?.backgroundColor = UIColor.blackColor()
    self.coverView?.alpha = 0
    self.coverView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight
    self.topView().addSubview(self.coverView!)
    
    self.alertView = UIView(frame: CGRectMake(0, 0, AlertWidth, AlertHeight))
    self.alertView?.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
    self.alertView?.layer.masksToBounds = true
    self.alertView?.layer.cornerRadius  = 5
    self.alertView?.backgroundColor = UIColor.whiteColor()
    
    self.addSubview(self.alertView!)
    
    // 设置title
    let labelHeigh = self.heighOfRow(self.title!, font: 17, width: AlertWidth - 2 * AlertPadding)
    self.labelTitle = UILabel(frame: CGRectMake(AlertPadding, AlertPadding, AlertWidth - 2 * AlertPadding, labelHeigh))
    self.labelTitle?.font      = UIFont.boldSystemFontOfSize(17)
    self.labelTitle?.textColor = UIColor.blackColor()
    self.labelTitle?.textAlignment = NSTextAlignment.Center
    self.labelTitle?.numberOfLines = 0
    self.labelTitle?.text = self.title
    self.labelTitle?.lineBreakMode = NSLineBreakMode.ByCharWrapping
    self.alertView?.addSubview(self.labelTitle!)
    
    // 设置message
    let messageHeigh = self.heighOfRow(self.message!, font: 14, width: AlertWidth - 2 * AlertPadding)
    self.labelmessage = UILabel(frame: CGRectMake(AlertPadding, self.labelTitle!.frame.origin.y + self.labelTitle!.frame.size.height, AlertWidth - 2 * AlertPadding, messageHeigh + 2 * AlertPadding))
    self.labelmessage?.font = UIFont.systemFontOfSize(14)

    let mesColor:UIColor = color ?? UIColor.blackColor()
    self.labelmessage?.textColor = mesColor
    self.labelmessage?.textAlignment = NSTextAlignment.Center
    self.labelmessage?.text = self.message
    self.labelmessage?.numberOfLines = 0
    self.labelmessage?.lineBreakMode = NSLineBreakMode.ByCharWrapping
    self.alertView?.addSubview(self.labelmessage!)
    
    self.contentScrollView = UIScrollView(frame: CGRectZero)
    self.alertView?.addSubview(self.contentScrollView!)
    
    UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    
    
  }
  
  // dealloc
  deinit {
   UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  // override func
  
  override func layoutSubviews() {
    self.buttonScrollView?.frame = CGRectMake(0, self.alertView!.frame.size.height-MenuHeight,self.alertView!.frame.size.width, MenuHeight);
    self.contentScrollView?.frame = CGRectMake(0, self.labelTitle!.frame.origin.y + self.labelTitle!.frame.size.height, self.alertView!.frame.size.width, self.alertView!.frame.size.height - MenuHeight);
    self.contentView?.frame = CGRectMake(0,0,self.contentView!.frame.size.width, self.contentView!.frame.size.height);
    if self.contentView != nil {
      self.contentScrollView?.contentSize = self.contentView!.frame.size;
    }
    
  }
  
  override func willMoveToSuperview(newSuperview: UIView?) {
    self.addButtonItem()
    if self.contentView != nil {
      self.contentScrollView?.addSubview(self.contentView!)
    }
    self.reLayout()
  }
  
  
  // show and dismiss
  func topView() -> UIView {
    let window = UIApplication.sharedApplication().keyWindow
    return (window?.subviews[0])!
  }
  
  func show() {
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      self.coverView?.alpha = 0.5
      }) { (finished) -> Void in
        
    }
    self.topView().addSubview(self)
    self.showAnimation()
  }
  
  //------Preoperties------
  func addButtonWithTitle(title:String) -> NSInteger {
    let item = DRSAlertDialogItem()
    item.title = title
    item.action = {(ite:DRSAlertDialogItem)->Void in
      print("no action")
    }
    item.type = ButtonType.Button_OK
    self.items?.addObject(item)
    
    return (self.items?.indexOfObject(title))!
  }
  
  func addButton(type:ButtonType, title:String, handler:((item:DRSAlertDialogItem) -> Void)) {
    let item = DRSAlertDialogItem()
    item.title = title
    item.action = handler
    item.type = type
    self.items?.addObject(item)
    
    item.tag = self.items?.indexOfObject(item)
  }
  
  
  func addButtonItem() {
    self.buttonScrollView = UIScrollView(frame: CGRectMake(0, self.alertView!.frame.size.height -  MenuHeight,AlertWidth, MenuHeight))
    self.buttonScrollView?.bounces = false
    self.buttonScrollView?.showsHorizontalScrollIndicator = false
    self.buttonScrollView?.showsVerticalScrollIndicator = false
    let width:CGFloat
    if (self.buttonWidth != nil) {
      width = self.buttonWidth!
      let a = CGFloat((self.items?.count)!)
      self.buttonScrollView?.contentSize = CGSizeMake(a * width, MenuHeight)
    }
    else {
      width = (self.alertView?.frame.size.width)! / CGFloat((self.items?.count)!)
    }
    self.items?.enumerateObjectsUsingBlock({ (item:AnyObject!, idx:Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
      let button = UIButton(type: UIButtonType.System)
      button.frame = CGRectMake(CGFloat(idx) * width, 1, width, MenuHeight)
      button.backgroundColor = UIColor.whiteColor()
      button.layer.shadowColor = UIColor.grayColor().CGColor
      button.layer.shadowRadius = 0.5
      button.layer.shadowOpacity = 1
      button.layer.shadowOffset = CGSizeZero
      button.layer.masksToBounds = false
      button.tag = 90000 + idx
      
      button.setTitle(item.title, forState: UIControlState.Normal)
      button.setTitle(item.title, forState: UIControlState.Selected)
      button.titleLabel?.font = UIFont.boldSystemFontOfSize((button.titleLabel?.font.pointSize)!)
      
      button.addTarget(self, action: "buttonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
      self.buttonScrollView?.addSubview(button)

      // 按钮边框
      if idx != (self.items?.count)! - 1 {
        let seprateLineVer = UIView(frame: CGRectMake(width - 1, 0, 2, MenuHeight))
        seprateLineVer.backgroundColor = UIColor.lightGrayColor()
        button.addSubview(seprateLineVer)
      }
      
      let seprateLineHor = UIView(frame: CGRectMake(0, 0, self.buttonScrollView!.frame.size.width, 1))
      seprateLineHor.backgroundColor = UIColor.lightGrayColor()
      self.buttonScrollView?.addSubview(seprateLineHor)
    })
    self.alertView?.addSubview(self.buttonScrollView!)
  }
  
  func buttonTouched(button:UIButton) {
    let item:DRSAlertDialogItem = self.items![button.tag - 90000] as! DRSAlertDialogItem
    if (item.action != nil) {
      item.action!(item: item)
    }
    self.dismiss()
  }
  
  func reLayout() {
    var plus:CGFloat
    if self.contentView != nil {
      plus = (self.contentView!.frame.size.height) - ((self.alertView?.frame.size.height)! - MenuHeight)
    }
    else {
      plus = (self.labelmessage?.frame.origin.y)! + (self.labelmessage?.frame.size.height)! - ((self.alertView?.frame.size.height)! - MenuHeight)
    }
    plus = max(0, plus)
    let height = min(self.screenBounds().size.height - MenuHeight, (self.alertView?.frame.size.height)! + plus)
    
    self.alertView?.frame = CGRectMake(self.alertView!.frame.origin.x, self.alertView!.frame.origin.y, AlertWidth, height)
    self.alertView?.center = self.center
    self.setNeedsDisplay()
    self.setNeedsLayout()
  }
  
  func dismiss() {
    self.hideAnimation()
  }
  
  func showAnimation() {
    let popAnimation = CAKeyframeAnimation(keyPath: "transform")
    popAnimation.duration = 0.4
    popAnimation.values   = [
      NSValue.init(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),
      NSValue.init(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
      NSValue.init(CATransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
      NSValue.init(CATransform3D: CATransform3DIdentity)
    ]
    popAnimation.keyTimes = [0.2, 0.5, 0.75, 1.0]
    popAnimation.timingFunctions = [
      CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
      CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut),
      CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
    ]
    self.alertView?.layer.addAnimation(popAnimation, forKey: nil)
  }
  
  func hideAnimation() {
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.coverView?.alpha = 0.0
      self.alertView?.alpha = 0.0
      }) { (finished) -> Void in
        self.removeFromSuperview()
    }
  }
  

  // handle device orientation changes
  func deviceOrientationDidChange(notification:NSNotification) {
    self.frame = self.screenBounds()
    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
      self.reLayout()
      }) { (finished) -> Void in
        
    }
  }
  
  
  //------Tools-------
  // 计算frame
  func screenBounds() -> CGRect {
    var screenWidth  = UIScreen.mainScreen().bounds.size.width
    var screenHeight = UIScreen.mainScreen().bounds.size.height
    // On iOS7, screen width and height doesn't automatically follow orientation
    if floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1 {
      let interfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
      if UIInterfaceOrientationIsLandscape(interfaceOrientation) {
        let tmp = screenWidth
        screenWidth = screenHeight
        screenHeight = tmp
      }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight)
  }
  
  // 计算字符串高度
  func heighOfRow(text:NSString, font:CGFloat, width:CGFloat) -> CGFloat {
    let wSize:CGSize = text.boundingRectWithSize(CGSizeMake(width, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(font)], context: nil).size
    
    return wSize.height;
  }


  

}
