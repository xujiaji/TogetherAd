//
//  ViewController.swift
//  TogetherAd
//
//  Created by xujiaji on 11/08/2021.
//  Copyright (c) 2021 xujiaji. All rights reserved.
//

import UIKit
import TogetherAd

class ViewController: UIViewController, AllAdListener, NativeExpressListener, FullVideoListener {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var currentInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TogetherAd.shared.allAdListener = self
    }
    
    func onAdStartRequest(providerType: String, alias: String) {
        currentInfo.text = "onAdStartRequest -> providerType = \(providerType), alias = \(alias)"
    }
    
    func onAdFailed(providerType: String, alias: String, failedMsg: String?) {
        currentInfo.text = "onAdFailed -> providerType = \(providerType), alias = \(alias), failedMsg = \(failedMsg ?? "")"
    }
    
    func onAdLoaded(providerType: String, alias: String) {
        currentInfo.text = "onAdLoaded -> providerType = \(providerType), alias = \(alias)"
    }
    

    @IBAction func onTapAddBanner(_ sender: Any) {
        let frame = UIScreen.main.bounds
        let bannerView = TogetherBannerView(alias: "banner", rootViewController: self, frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        bannerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(bannerView)
    }
    
    @IBAction func onTapLoadAndShowFullVideo(_ sender: Any) {
        let helper = AdHelperFullVideo(alias: "fullscreen")
        helper.loadAndShow(fromRootViewController: self)
    }
    
    var adHelperFullVideo: AdHelperFullVideo? = nil
    @IBAction func onTapLoadFullVideo(_ sender: Any) {
        adHelperFullVideo = AdHelperFullVideo(alias: "fullscreen", delegate: self)
        adHelperFullVideo?.load()
    }
    
    func onAdVideoCached(providerType: String) {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "显示全屏视频"
            button.configuration = config
        } else {
            // Fallback on earlier versions
            button.setTitle("显示全屏视频", for: .normal)
        }
        button.addTarget(self, action: #selector(onTopShowFullVideo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.widthAnchor.constraint(equalToConstant: stackView.frame.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        stackView.addArrangedSubview(button)
    }
    
    @objc func onTopShowFullVideo() {
        let isShowed = adHelperFullVideo?.show(fromRootViewController: self)
        "onTopShowFullVideo isShowed = \(isShowed ?? false)".logi()
    }
    
    @IBAction func onTapLoadAndShowReward(_ sender: Any) {
        let helper = AdHelperReward(alias: "reward")
        helper.loadAndShow(fromRootViewController: self)
    }
    
    @IBAction func onTapLoadAndShowInter(_ sender: Any) {
        let helper = AdHelperInter(alias: "inter")
        helper.loadAndShow(fromRootViewController: self)
    }
    
    var nativeExpress: UIView? = nil
    @IBAction func onTapLoadAndShowNativeExpress(_ sender: Any) {
        let frame = UIScreen.main.bounds
        // 高度自适应的时候填0
        nativeExpress = TogetherNativeExpressView(alias: "native", delegate: self, rootViewController: self, frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
    }
    
    func onAdRenderSuccess(providerType: String, adObject: Any?) {
        if let nativeExpress = nativeExpress {
            nativeExpress.heightAnchor.constraint(equalToConstant: nativeExpress.frame.height).isActive = true
            stackView.addArrangedSubview(nativeExpress)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

