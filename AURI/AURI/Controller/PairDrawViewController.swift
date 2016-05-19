//
//  PairDrawViewController.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/18.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PairDrawViewController: UIViewController,MCBrowserViewControllerDelegate,MCSessionDelegate,CanvasTouchUpDelegate{

    
    @IBOutlet weak var drawView: DrawableView!
    
    //このサービスの名前
    let serviceType = "local-canvas"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawView.canvasTouchUpDelegate = self
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // 自動でpeerを検出し、招待を送れるビューコントローラを作成してくれるインスタンス
        self.browser = MCBrowserViewController(serviceType:serviceType,session:self.session)
        self.browser.delegate = self;
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,discoveryInfo:nil, session:self.session)
        self.assistant.start()
        
        self.presentViewController(self.browser, animated: true, completion: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        //ナビゲーションバーを表示します
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //フリックで戻るのを禁止します
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    //Doneボタンを押した時の処理
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController)  {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //キャンセルを押した時の処理
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController)  {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // peerからデータを受信した時に呼ばる処理
    func session(session: MCSession, didReceiveData data: NSData,fromPeer peerID: MCPeerID)  {
        // This needs to run on the main queue
        dispatch_async(dispatch_get_main_queue()) {
//            let canvasInfo = NSKeyedUnarchiver.unarchiveObjectWithData(data)
//            self.drawView.paths = (canvasInfo?.paths)!
//            self.drawView.colors = (canvasInfo?.colors)!
                print(data)
        }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession,didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, withProgress progress: NSProgress)  {
        
        // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession,didFinishReceivingResourceWithName resourceName: String,
                                                    fromPeer peerID: MCPeerID,
                                                             atURL localURL: NSURL, withError error: NSError?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream,withName streamName: String, fromPeer peerID: MCPeerID)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession, peer peerID: MCPeerID,
                 didChangeState state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        
    }
    //キャンバスから指を離した時に呼ばれるメソッド
    func canvasTouchUp() {
//        let msg = "hello!".dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: false)
        try! self.session.sendData(drawView.getCanvasForNSData(),toPeers: self.session.connectedPeers,withMode:MCSessionSendDataMode.Reliable)
        print("指を離したのでデータを送信")
    }

    
}
