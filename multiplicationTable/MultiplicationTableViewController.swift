//
//  MultiplicationTableViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/10.
//

import UIKit

class MultiplicationTableViewController: UIViewController {

    @IBOutlet weak var changeDisplaySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var singleTableLabel: UILabel!
    
    @IBOutlet weak var wholeColumnView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var x = 5
    var y = 5
    let side = 42
    var num1 = 1
    var num2 = 1
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeColumn()
        displayColumns()
        // Do any additional setup after loading the view.
         backgroundImageView.image = UIImage.animatedImageNamed("amusement2-", duration: 10)
        view.sendSubviewToBack(backgroundImageView)
        wholeColumnView.backgroundColor = .clear
    }
    
    func makeAFrame(x: Int, y: Int) -> CALayer{
        
        let framePath = UIBezierPath()
        framePath.move(to: CGPoint(x: x, y: y))
        framePath.addLine(to: CGPoint(x: x, y: y+side))
        framePath.addLine(to: CGPoint(x: x+side, y: y+side))
        framePath.addLine(to: CGPoint(x: x+side, y: y))
        framePath.close()
        
        let frameLayer = CAShapeLayer()
        frameLayer.path = framePath.cgPath
        frameLayer.lineWidth = 0.5
        frameLayer.strokeColor = UIColor.init(white: 0, alpha: 1).cgColor
        frameLayer.fillColor = UIColor.clear.cgColor
        
        return frameLayer
    }
    
    func makeColumn(){
        for num1 in 0...9 {
            y += side
            x = 5
            
            for num2 in 0...9 {
                let num = UILabel(frame: CGRect(x: x+5, y: y+5, width: side-10, height: side-10))
                num.textAlignment = .center
                if num1 == 0 {
                    num.text = "\(num2)"
                } else if num2 == 0 {
                    num.text = "\(num1)"
                } else {
                    num.text = "\(num1*num2)"
                }
                wholeColumnView.addSubview(num)
               
                wholeColumnView.addSubview(makeAButton())
                wholeColumnView.layer.addSublayer( makeAFrame(x: x, y: y))
                x += side
            }
        }
    }
    
    @objc func displayButtonColors(){
        var buttonIndex = 0
        var coloredNum = 0
        
        for i in 0...9 {
            buttons[i].isEnabled = false
            if i == 0 {
                for n in stride(from: 10, to: 90, by: 10) {
                    buttons[n].isEnabled = false
                }
            }
        }
        
        for i in 0...buttons.count-1 {
            buttons[i].backgroundColor = .clear
        }
        
        while !buttons[buttonIndex].isTouchInside {
            //buttons[buttonIndex].backgroundColor = .clear
            buttonIndex += 1
        }
        
        
        for i in 1...3 {
            if i == 2 {
                coloredNum = buttonIndex%10
            } else if i == 3 {
                coloredNum = buttonIndex-coloredNum
            } else {
                coloredNum = buttonIndex
            }
            buttons[coloredNum].backgroundColor = .red
            buttons[coloredNum].alpha = 0.3
        }
    }
    
    func makeAButton() -> UIButton{
        let button = UIButton()
        button.frame = CGRect(x: x, y: y, width: side, height: side)
        
        button.addTarget(self, action: #selector(displayButtonColors), for: .touchUpInside)
        
        buttons.append(button)
        return button
    }
    
    func makeNums(num1: Int){
        singleTableLabel.text = ""
        num2 = 1
        
        for _ in 1...9 {
            singleTableLabel.text! += "\(num1) X \(num2) = \(num1*num2) \n"
            num2 += 1
        }
    }
    
    func displayColumns(){
        if changeDisplaySegmentedControl.selectedSegmentIndex == 0 {
            wholeColumnView.isHidden = false
            singleTableLabel.isHidden = true
        } else {
            wholeColumnView.isHidden = true
            singleTableLabel.isHidden = false
            makeNums(num1: num1)
        }
    }
    
    @IBAction func changeDisplay(_ sender: UISegmentedControl) {
        displayColumns()
    }
    
    @IBAction func changeNums(_ sender: UISwipeGestureRecognizer) {
        if singleTableLabel.isHidden == false {
            if sender.direction == .left {
                num1 = (num1+1)%9
            } else {
                num1 = (num1-1+9)%9
            }
            
            if num1 == 0 {
                num1 = 9
            }
            
            makeNums(num1: num1)
        }
    }
    
    
    
}
