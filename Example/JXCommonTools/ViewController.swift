//
//  ViewController.swift
//  JXCommonTools
//
//  Created by m1 on 04/13/2023.
//  Copyright (c) 2023 m1. All rights reserved.
//

import UIKit
import SnapKit
import JXCommonTools

class ViewController: UITableViewController {

    var source = [
        "JXCenterFlowLayoutDemo",
        "JXAlertView",
        "JXTipLabel",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell") }
        
        cell.textLabel?.text = source[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = (JXWindow.jx_classFrom(className: source[indexPath.row]) as? UIViewController.Type)?.init() else {
            other(title: source[indexPath.row])
            return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func other(title: String?) {
        guard let title = title else { return }
        
        if title == "JXAlertView" {
            JXAlertViewDemo()
            return
        }
        if title == "JXTipLabel" {
            JXTipLabelDemo()
            return
        }
    }
    
    // MARK: - JXAlertView
    func JXAlertViewDemo() {
//        JXAlertView.jx_show(toView: nil, title: "title", message: "message") { index, alert in
//            print(index)
//        }
        
        let alert = JXAlertView.jx_show(toView: nil, title: "title(jx_autoRemove == false)", message: "message") { index, alert in
            print(index)
        }
        alert?.jx_autoRemove = false
    }
    
    // MARK: - JXTipLabel
    static var longText: String = ""
    func JXTipLabelDemo() {
        
        ViewController.longText.append("toast可以很长很长很长很长～")
        
        JXTipLabel.jx_show(text: ViewController.longText, duration: 5)
        
    }
    
}

