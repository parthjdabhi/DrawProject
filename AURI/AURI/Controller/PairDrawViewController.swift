//
//  PairDrawViewController.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/18.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PairDrawViewController: UIViewController,MCBrowserViewControllerDelegate,MCSessionDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CanvasTouchUpDelegate,ImageAddButtonTouch{

    //drawView本体
    @IBOutlet weak var drawView: DrawableView!
    //ゴミ箱ボタン
    @IBOutlet weak var trashButton: UIBarButtonItem!
    //ゴミ箱判定エリア
    @IBOutlet weak var trashArea: UIView!
    
    //このサービスの名前
    let serviceType = "local-canvas"
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    var pictureView:PictureView?
    var imageViewAssist:ImageViewSizeAssist?
    
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
    
    @IBAction func imageAddButtonAction(sender: AnyObject) {
        pickImageFromLibrary()
    }
    
    //「写真」を開くメソッド
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言しているという理解
            let controller = UIImagePickerController()
            
            //おまじないという認識で今は良いと思う
            controller.delegate = self
            
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            //以下はカメラロールの例
            //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    /**
     写真を選択した時に呼ばれる (swift2.0対応)
     
     :param: picker:おまじないという認識で今は良いと思う
     :param: didFinishPickingMediaWithInfo:おまじないという認識で今は良いと思う
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String: AnyObject]) {
        
        //このif条件はおまじないという認識で今は良いと思う
        if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
            
            //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報が入っている？)をUIImageにCastする
            //そしてそれを宣言済みのimageViewへ放り込む
            //pictureViewが1度も生成されていない場合
            if self.pictureView == nil{
                self.pictureView = PictureView(superView:self.view,trashButton:trashButton,trashArea:self.trashArea)
            }else if self.pictureView?.hidden == true{//非表示の場合
                self.pictureView?.hidden = false
            }
            
            self.pictureView!.frame = CGRectMake(self.view.frame.width / 2 - 100,self.view.frame.height/2 - 75, 200, 150)
            self.pictureView!.image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage
            //imageViewAssistが1度も生成されていない場合
            if self.imageViewAssist == nil{
                imageViewAssist = ImageViewSizeAssist(imageView:pictureView!,superView:self.view)
                imageViewAssist?.image_add_View?.imageAddButtonTouch = self
            }else if imageViewAssist?.hidden == true{//非表示の場合
                imageViewAssist?.visible()
                imageViewAssist?.update(pictureView!)
            }
            self.view.addSubview(pictureView!)
        }
        
        //写真選択後にカメラロール表示ViewControllerを引っ込める動作
        picker.dismissViewControllerAnimated(true, completion: nil)
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
    
        
        dispatch_async(dispatch_get_main_queue(), {
            print("データ受信")
            let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            if (s as? Canvas) != nil{
                print("Canvasが送信されました")
                self.drawView.addCanvas(data)
            }else if (s as? CanvasImage) != nil{
                print("canvasImageが送信されました")
                self.drawView.addCanvasImage(data)
            }else{
                print("該当なしです...")
            }
        })
        
        
//        print("データ受信")
//        let s = NSKeyedUnarchiver.unarchiveObjectWithData(data)
//        if (s as? Canvas) != nil{
//            print("Canvasが送信されました")
//            self.drawView.addCanvas(data)
//        }else if (s as? CanvasImage) != nil{
//            print("canvasImageが送信されました")
//            self.drawView.addCanvasImage(data)
//        }else{
//            print("該当なしです...")
//        }
    
    
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
        do {
            try self.session.sendData(drawView.getCanvasForNSData(),toPeers: self.session.connectedPeers,withMode: MCSessionSendDataMode.Unreliable)
        } catch {
            print(error)
        }
        print("指を離したのでデータを送信")

    }
    //画像貼り付けボタンが押された時の処理
    func imageAddButtonTouch() {
        print("画像データを送信")
        let canvasImage = CanvasImage(image:pictureView!.image!, frame:NSValue(CGRect: pictureView!.frame))
        drawView.drawImage(canvasImage)
        //AssistView　およぼ PictureViewを非表示にします
        imageViewAssist?.invisible()
        //処理を分散
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(queue,{
            do {
                try self.session.sendData(self.drawView.getImageForNSData(),toPeers: self.session.connectedPeers,withMode: MCSessionSendDataMode.Unreliable)
            } catch {
                print(error)
            }
        })

        
        
    }
}
