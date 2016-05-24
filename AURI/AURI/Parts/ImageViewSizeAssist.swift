//
//  ImageViewSizeAssist.swift
//  アウリクラリア
//
//  Created by 木耳ちゃん on 2016/05/17.
//  Copyright © 2016年 NeTGroup. All rights reserved.
//

import Foundation
import UIKit

class ImageViewSizeAssist:PictureTouchMove,PartsTouchMove{
    
    //左中央のパーツ
    var left_center_View:LeftCenterParts?
    //右中央のパーツ
    var right_center_View:RightCenterParts?
    //上中央のパーツ
    var top_center_View:TopCenterParts?
    //下中央パーツ
    var bottom_center_View:BottomCenterParts?
    //左上パーツ
    var left_top_View:LeftTopParts?
    //右上パーツ
    var right_top_View:RightTopParts?
    //左下パーツ
    var left_bottom_View:LeftBottomParts?
    //右下パーツ
    var right_bottom_View:RightBottomParts?
    //ターゲットのImageView
    weak var targetImageView:PictureView?
    //背景の点線のView
    var dotView:DotView?
    
    init(imageView:PictureView,superView:UIView){
        //Partsの初期設定を行います//
        Parts.marginVertical = 0
        Parts.marginHorizontal = 0
        //DotViewの初期設定を行います//
        DotView.width = imageView.frame.width + Parts.marginHorizontal * 2 + DotView.paddingHorizontal*2
        DotView.height = imageView.frame.height + Parts.marginVertical * 2 + DotView.paddingVertical*2
        ///////////////////////////////////
        // ImageViewの初期化
        self.targetImageView = imageView
        self.targetImageView?.pictureTouchMove = self
        //ドット背景の作成
        self.dotView = DotView(imageView:targetImageView!)
        superView.addSubview(dotView!)
        //左中央生成
        left_center_View = LeftCenterParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        left_center_View?.partsTouchMove = self
        superView.addSubview(left_center_View!)
        //右中央生成
        right_center_View = RightCenterParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        right_center_View?.partsTouchMove = self
        superView.addSubview(right_center_View!)
        //上中央生成
        top_center_View = TopCenterParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        top_center_View?.partsTouchMove = self
        superView.addSubview(top_center_View!)
        //下中央生成
        bottom_center_View = BottomCenterParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        bottom_center_View?.partsTouchMove = self
        superView.addSubview(bottom_center_View!)
        //左上作成
        left_top_View = LeftTopParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        left_top_View?.partsTouchMove = self
        superView.addSubview(left_top_View!)
        //右上作成
        right_top_View = RightTopParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        right_top_View?.partsTouchMove = self
        superView.addSubview(right_top_View!)
        //左下作成
        left_bottom_View = LeftBottomParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        left_bottom_View?.partsTouchMove = self
        superView.addSubview(left_bottom_View!)
        //右下作成
        right_bottom_View = RightBottomParts(superView:superView,targetImageView:imageView,dotView:dotView!)
        right_bottom_View?.partsTouchMove = self
        superView.addSubview(right_bottom_View!)
        
    }
    

    //ImageViewが動いた時の処理
    func pictureMove() {
        //以下コードでImageViewと一緒に動くことができるようになります。
        left_center_View?.pictureMove()
        right_center_View?.pictureMove()
        top_center_View?.pictureMove()
        bottom_center_View?.pictureMove()
        left_top_View?.pictureMove()
        right_top_View?.pictureMove()
        left_bottom_View?.pictureMove()
        right_bottom_View?.pictureMove()
        dotView?.pictureMove()
    }
    
    func partsTouchMove(parts: Parts) {
        switch parts {
        case parts as LeftCenterParts:
            //右中央
            right_center_View?.pictureMove()
            //上中央
            top_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as TopCenterParts:
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as BottomCenterParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as RightCenterParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as LeftTopParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as RightTopParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as LeftBottomParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //右下
            right_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        case parts as RightBottomParts:
            //上中央
            top_center_View?.pictureMove()
            //左中央
            left_center_View?.pictureMove()
            //右中央
            right_center_View?.pictureMove()
            //下中央
            bottom_center_View?.pictureMove()
            //右上
            right_top_View?.pictureMove()
            //左上
            left_top_View?.pictureMove()
            //左下
            left_bottom_View?.pictureMove()
            //再描写
            dotView?.repaint()
        default:
            break
        }
        
    }
}