//
    //  Test.swift
    //  Pix
    //
    //  Created by Adeola Uthman on 12/31/16.
    //  Copyright © 2016 Adeola Uthman. All rights reserved.
    //
    
import UIKit
import SnapKit

    
class Test: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!;
    var imageView: UIImageView!;



    override func viewDidLoad() {
            super.viewDidLoad();
    
            let vWidth = CGFloat(self.view.frame.width)
            let vHeight = CGFloat(self.view.frame.height)
        
                imageView = UIImageView(image: UIImage(named: "trolltunga.jpeg"));
            scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
                scrollView.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
                scrollView.delegate = self
                scrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
                scrollView.alwaysBounceVertical = true
                scrollView.alwaysBounceHorizontal = true
                scrollView.flashScrollIndicators()
        
                scrollView.minimumZoomScale = 1.0
                scrollView.maximumZoomScale = 10.0
        //scrollView.zoomScale = 1.0;
        
                view.addSubview(scrollView)
                
                imageView!.layer.cornerRadius = 11.0
        imageView.frame = scrollView.frame;
        scrollView.contentSize = imageView.frame.size;
                imageView.contentMode = .scaleAspectFit;
                imageView!.clipsToBounds = false
                scrollView.addSubview(imageView!)
        
        
        scrollView.snp.makeConstraints { (maker: ConstraintMaker) in
            maker.left.equalTo(0);
            maker.right.equalTo(view.snp.right);
            maker.top.equalTo(0);
            maker.height.equalTo(200);
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView;
        }

}
