//
//  JXTool.swift
//  JXCommonTools
//
//  Created by 1 on 2023/5/12.
//

import Foundation
import UIKit
import Photos

class JXTool {
    // MARK: - 跳相机
    static func jx_go_Camera(_ vc: UIViewController? = nil) -> UIImagePickerController? {
        let t = JXTool.jx_camera_permissions()
        if t == -1 {
            return nil
        }
        guard t == 0 || t == 3 else {
            jx_permissions_jump()
            return nil }
        
        var viewController = vc
        if viewController == nil {
            viewController = JXWindow.currentViewController
        }
        let  cameraPicker = UIImagePickerController()
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        viewController?.present(cameraPicker, animated: true, completion: nil)
        return cameraPicker
    }
    
    // MARK: - 权限 0未知；1受限； 2拒绝；3.允许；4部分；
    /// 跳设置，默认有弹窗
    static func jx_permissions_jump(_ toAlert: Bool = true) {
        if toAlert {
            let alert = UIAlertController(title: "提示", message: "权限部分受限，是否跳转到设置打开", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
            let jumpAction = UIAlertAction(title: "确定", style: .default) { action in
                self.jx_permissions_jump(false)
            }
            alert.addAction(cancelAction)
            alert.addAction(jumpAction)
            
            JXWindow.currentViewController?.present(alert, animated: true, completion: nil)
            return
        }
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { succ in
            print("打开系统设置:\(succ)")
        }
    }
    
    /// 相机权限 0未知；1受限； 2拒绝；3.允许；4部分；
    static func jx_camera_permissions() -> Int {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true else {
//            ("相机不可使用")
            return -1 }
        return AVCaptureDevice.authorizationStatus(for: .video).rawValue
    }
    static func jx_camera_permissions_req(_ block: ((_ granted: Bool) -> Void)? = nil) {
        let permissions = jx_camera_permissions()
        guard permissions != -1 else { return }
        if permissions == 0 {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    block?(granted)
                    print("jx_camera_permissions_req:\(granted)")
                }
            }
            return
        }
        if permissions == 3 {
            return
        }
        jx_permissions_jump()
    }
    
    
    /// 相册权限 0未知；1受限； 2拒绝；3.允许；4部分；
    static func jx_album_permissions() -> Int {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite).rawValue
        } else {
            return PHPhotoLibrary.authorizationStatus().rawValue
        }
    }
    static func jx_album_permissions_req(_ block: ((_ status: Int) -> Void)? = nil) {
        let permissions = jx_album_permissions()
        if permissions == 0 {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    block?(status.rawValue)
                    print("jx_album_permissions_req:\(status.rawValue)")
                }
            }
            return
        }
        if permissions == 3 {
            return
        }
        jx_permissions_jump()
    }
    /// 麦克风权限 0未知；1受限； 2拒绝；3.允许；4部分；
    static func jx_mic_permissions() -> Int {
        return AVCaptureDevice.authorizationStatus(for: .audio).rawValue
    }
    static func jx_mic_permissions_req(_ block: ((_ granted: Bool) -> Void)? = nil) {
        let permission = AVAudioSession.sharedInstance().recordPermission
        if permission == .undetermined {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    block?(granted)
                    print("jx_mic_permissions_req:\(granted)")
                }
            }
            return
        }
        if permission == .granted {
            return
        }
        jx_permissions_jump()
    }
    
}
