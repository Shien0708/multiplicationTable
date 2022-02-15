//
//  ChooseLevelViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/11.
//

import UIKit

var levelLabelString: String?

func setSeconds(){
    countDownSecond = Float(level) * 30
}


class ChooseLevelViewController: UIViewController {
    
    @IBOutlet weak var baseballImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var changeLevelStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        baseballImageView.image = UIImage.animatedImageNamed("baseballGif-", duration: 1)
        levelLabel.text = "\(level)"
        changeLevelStepper.value = Double(level)
    }
    
    func changeLevelLabel(){
        if let level = levelLabelString {
            changeLevelStepper.value = Double(Int(level)!)
            levelLabel.text = "\(Int(changeLevelStepper.value))"
        } else {
            print("nil")
        }
    }
    
    @IBAction func changeLevel(_ sender: UIStepper) {
        level = Int(sender.value)
        levelLabel.text = "\(level)"
        levelLabelString = "\(level)"
    }
    
    @IBAction func startGame(_ sender: Any) {
        totalProgressValue = 1
        setSeconds()
    }
    
    
    @IBAction func backToMenu(segue: UIStoryboardSegue) {
        changeLevelLabel()
    }
    
    
}
