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
        guard let vc = (JXWindow.jx_classFrom(className: source[indexPath.row]) as? UIViewController.Type)?.init() else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

