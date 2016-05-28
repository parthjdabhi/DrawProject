//
//  DrawViewController.swift
//  AURI
//
//  Created by 木耳ちゃん on 2016/05/07.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageAddButtonTouch{
    
    /////StoryBoard上のUI関係/////
    //drawView本体
    @IBOutlet weak var drawView: DrawableView!
    //ゴミ箱ボタン
    @IBOutlet weak var trashButton: UIBarButtonItem!
    //ペンボタン
    @IBOutlet weak var penButton: KikurageButton!
    //消しゴムボタン
    @IBOutlet weak var eraserButton: KikurageButton!
    //色ボタン
    @IBOutlet weak var colorButton: UIButton!
    //太さボタン
    @IBOutlet weak var thicknessButton: UIButton!
    //線ボタン
    @IBOutlet weak var lineButton: UIButton!
    /////その他UI関係/////
    var pictureView:PictureView?
    var imageViewAssist:ImageViewSizeAssist?
    
    @IBOutlet weak var trashArea: UIView!
    
    /////------/////
    override func viewDidLoad() {
        super.viewDidLoad()
        //ペンボタンが選択された状態になります。
        penButton.select = true
        penButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha:1)
        
    }
    override func viewWillAppear(animated: Bool) {
        //ナビゲーションバーを表示します
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //フリックで戻るのを禁止します
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
    }
    //ナビゲーションバーのゴミ箱が押された時の処理
    @IBAction func clear(sender: AnyObject) {
        drawView.clear()
    }
    
    //ペンボタンが押された時の処理
    @IBAction func penAction(sender: AnyObject) {
        if !penButton.select && eraserButton.select{
            penButton.select = true
            eraserButton.select = false
            penButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha:1)
            eraserButton.backgroundColor = UIColor.clearColor()
        }
    }
    
    //消しゴムボタンを押された時の処理
    @IBAction func eraserAction(sender: AnyObject) {
        if penButton.select && !eraserButton.select{
            eraserButton.select = true
            penButton.select = false
            penButton.backgroundColor = UIColor.clearColor()
            eraserButton.backgroundColor = UIColor(red:0,green:122/255,blue:1,alpha:1)
            drawView.setColor(UIColor.whiteColor())
        }
    }
    //画像追加ボタンが押された時の処理
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
    
    func imageAddButtonTouch() {
        drawView.addImage((pictureView?.image)!,rect:(pictureView?.frame)!)
        //AssistView　およぼ PictureViewを非表示にします
        imageViewAssist?.invisible()
    }
    
}
