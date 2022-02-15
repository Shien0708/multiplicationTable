//
//  ViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var balloonImageViews: [UIImageView]!
    @IBOutlet weak var memoryGameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for i in 0...balloonImageViews.count-1{
            balloonImageViews[i].image = UIImage.animatedImageNamed("balloonGif-", duration: 1)
        }
    }

    
    
}

