//
//  Test.swift
//  Pix
//
//  Created by Adeola Uthman on 12/31/16.
//  Copyright © 2016 Adeola Uthman. All rights reserved.
//

import UIKit


class Test: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!;
    var imageView: UIImageView!;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let vWidth = CGFloat(self.view.frame.width)
        let vHeight = CGFloat(self.view.frame.height)
        
        imageView = UIImageView(image: UIImage(named: "friends_icon@3x.png"));
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        view.addSubview(scrollView)
        
        imageView!.layer.cornerRadius = 11.0
        imageView!.clipsToBounds = false
        scrollView.addSubview(imageView!)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView;
    }
    
}
