//
//  ViewController.swift
//  DRSAlertDialog
//
//  Created by Xiaoqiang Zhang on 16/3/2.
//  Copyright © 2016年 Xiaoqiang Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var _promptView:UIView?
  
  var _promptLabel:UILabel!
  
  var _table:UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.designContentView()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func designContentView() {

    _promptView = UIView(frame: CGRectMake(0, 0, 300, 50))
    
    let _promptButton = UIButton(type: UIButtonType.Custom)
    _promptButton.frame = CGRectMake(10, 0, 36, 50)
    _promptButton.setImage(UIImage(named: "sign_noral"), forState: UIControlState.Normal)
    _promptButton.setImage(UIImage(named: "sign_select"), forState: UIControlState.Highlighted)
    _promptButton.setImage(UIImage(named: "sign_select"), forState: UIControlState.Selected)
    
    _promptButton.addTarget(self, action: "selectButton:", forControlEvents: UIControlEvents.TouchUpInside)
    
    _promptView!.addSubview(_promptButton)
    
    _promptLabel = UILabel(frame: CGRectMake(50, 0, 220, 50))
    
    _promptLabel.text      = "我确认，已认真阅读如上提醒！^_^";
    _promptLabel.textColor = UIColor.redColor()
    _promptLabel.font      = UIFont.systemFontOfSize(14)
    
    _promptView!.addSubview(_promptLabel)
    
    
    _table = UITableView(frame: CGRectMake(0, 0, 300, 300), style: UITableViewStyle.Plain)
    _table.delegate = self
    _table.dataSource = self
    
  }
  
  @IBAction func showNormal(sender: AnyObject) {
    
    // 创建alert
    let alert = DRSAlertDialog(title: "提示", message: "卡的身份暗淡咖啡及阿尔基金安抚啊发简历到开封卡时间对伐啦拉宽带费拉开到家里阿里快速的房间里卡里的风景", messageColor: UIColor.redColor())
    
    alert.addButton(ButtonType.Button_OTHER, title: "取消") { (item) -> Void in
      print(item.title)
    }
    
    alert.addButton(ButtonType.Button_OTHER, title: "确定") { (item) -> Void in
      print(item.title)
    }
    
    alert.show()
    
  }
  
  @IBAction func showCheck(sender: AnyObject) {
    // 使用alert
    let alert = DRSAlertDialog(title: "提示", message: "", messageColor: nil)
    alert.contentView = _promptView
    alert.addButton(ButtonType.Button_OTHER, title: "取消") { (item) -> Void in
      print(item.title)
    }
    
    alert.addButton(ButtonType.Button_OTHER, title: "确定") { (item) -> Void in
      print(item.title)
    }
    
    alert.show()
  }
  
  @IBAction func showTable(sender: AnyObject) {
    // 使用alert
    let alert = DRSAlertDialog(title: "提示", message: "", messageColor: nil)
    alert.contentView = _table
    alert.addButton(ButtonType.Button_OTHER, title: "取消") { (item) -> Void in
      print(item.title)
    }
    
    alert.addButton(ButtonType.Button_OTHER, title: "确定") { (item) -> Void in
      print(item.title)
    }
    
    alert.show()
  }
  
  // 自定义的视图响应事件
  func selectButton(button:UIButton) {
    if button.selected {
      button.selected = false
      self._promptLabel.textColor = UIColor.redColor()
    }
    else {
      button.selected = true
      self._promptLabel.textColor = UIColor.blackColor()
    }
  }
  
  // tableview delegate&datasource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ce")
    cell.textLabel?.text = "bit it"
    return cell
  }
  
}

