//
//  HelperViewController.swift
//  BubbleWarV1
//
//  Created by Bowen Zhang on 4/18/19.
//  Copyright © 2019 nyu.edu. All rights reserved.
//

import UIKit

class HelperViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 812, height: 812))
        let imageView = UIImageView(frame: rect);
        let image = UIImage(named: "helper_bg2");
        imageView.image = image;
        myView.addSubview(imageView);
    }
}
