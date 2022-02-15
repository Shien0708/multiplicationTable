//
//  MemoryGameViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/9.
//

import UIKit
var level = 1
var num1 = 0
var num2 = 0
var questions = [String]()

var countDownSecond: Float = 1
var totalProgressValue: Float = 1

var countDownTimer: Timer?

class MemoryGameViewController: UIViewController {
    var y = 200
    var x = 200
    var block = 1
    var pressedTimes = 0
    var isCorrect = false
    var alphaTimer: Timer?
    var animator = UIViewPropertyAnimator()
    
    var answers = [String]()
    var buttons = [UIButton]()
    var columnViews = [UIView]()
    var buttonIndex = [Int]()
    var CGPoints = [CGPoint]()

    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var timeProgress: UIProgressView!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var baseballImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.alpha = 0
        
        makeBlocks()
        
        countDown()
    }
   
    func countDown(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setGameTime), userInfo: nil, repeats: true)
    }
    
    @objc func setGameTime(){
        totalProgressValue -= Float(100/countDownSecond)*0.01
        
        timeProgress.progress = totalProgressValue
        
        if timeProgress.progress == 0 {
            countDownTimer?.invalidate()
            resultLabel.text = "Time's Up!"
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.view.bringSubviewToFront(self.resultView)
                self.resultView.alpha = 1
            })
            animator.startAnimation()
            if level == 1 {
                preButton.isEnabled = false
            } else if level == 5 {
                nextButton.isEnabled = false
            } else {
                preButton.isEnabled = true
                nextButton.isEnabled = true
            }
        } 
    }
    
    
    func makeBlocks(){
        let columnView = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 896))
        questions = []
        myQuestions = []
        block = 1
        y = 200
        
        
        for _ in 1...level*2 {
            for i in 1...level*2{
                if i % 2 == 1 {
                    num1 = Int.random(in: 1...9)
                    num2 = Int.random(in: 1...9)
                    
                    myQuestions.append(Question(question: "\(num1) X \(num2)", answer: "\(num1*num2)"))
                    questions.append(myQuestions[block-1].answer)
                } else {
                    questions.append(myQuestions[block-1].question)
                    block += 1
                }
            }
        }
        
        block = 1
        questions.shuffle()
        
        for _ in 1...level*2{
            
            for n in 1...level*2 {
                
                let answer = UILabel()
                let button = UIButton()
                
                CGPoints.append(CGPoint(x: x*n/level-level+10, y: y))
                
                answer.frame = CGRect(x: x*n/level-x/level+10, y: y, width: 200/level, height: 200/level)
                    answer.font = UIFont.systemFont(ofSize: CGFloat(50/level))
                button.frame = CGRect(x: x*n/level-x/level+10 , y: y, width: 200/level, height: 200/level)
                button.layer.cornerRadius = CGFloat(200/level/2)
               
                answer.text = questions[block-1]
                answer.textAlignment = .center
                answer.textColor = .black
                columnView.addSubview(answer)
                
                button.addTarget(self, action: #selector(press), for: .touchUpInside)
                button.setTitle("\(block)", for: .normal)
                button.setTitleColor(.red, for: .normal)
                button.backgroundColor = .white
                button.layer.shadowOffset = CGSize(width: 5, height: 5);
                button.layer.shadowOpacity = 5
                columnView.addSubview(button)
                buttons.append(button)
                
                //view.addSubview(block)
                block += 1
            }
            
            y += 200/level
        }
        columnViews.append(columnView)
        view.addSubview(columnViews.first!)
    }
    
    func setDisplayButtonTimer(){
        if isCorrect == true {
            alphaTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(removeButton), userInfo: nil, repeats: false)
        } else {
            alphaTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(displayButton), userInfo: nil, repeats: false)
        }
    }
    
    
    @objc func removeButton(){
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.buttons[self.buttonIndex.last!].alpha = 0
                if self.buttonIndex.count > 1 {
                    self.buttons[self.buttonIndex.last!].alpha = 0
                }
            })
        
        animator.startAnimation()
        
        var alphaIsZero = 0
        
        for i in 0...buttons.count-1 {
            if buttons[i].alpha == 0 {
                alphaIsZero += 1
            }
        }
        
        if alphaIsZero == buttons.count {
            countDownTimer?.invalidate()
            resultLabel.text = "Congradulations!"
            let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                self.view.bringSubviewToFront(self.resultView)
                self.resultView.alpha = 1
            }
            animator.startAnimation()
            if level == 1 {
                preButton.isEnabled = false
            } else if level == 5 {
                nextButton.isEnabled = false
            } else {
                preButton.isEnabled = true
                nextButton.isEnabled = true
            }
        }
    }
    
    @objc func displayButton(){
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
            self.buttons[self.buttonIndex[0]].alpha = 1
            self.buttons[self.buttonIndex[1]].alpha = 1
           
        })
       
        animator.startAnimation()
    }
    
    @objc func press(){
        var button = 0
        
        while !buttons[button].isTouchInside && button < level*level*4-1 {
            button += 1
        }
        
        buttonIndex.append(button)
        isCorrect = true
        setDisplayButtonTimer()
        
        if pressedTimes == 1 {
            pressedTimes = 0
            var checkIndex = 0
            isCorrect = false
            
            if buttonIndex.count > 2 {
                buttonIndex.removeFirst()
                buttonIndex.removeFirst()
            }
            
            while isCorrect == false && checkIndex <= block/2-1{
                if myQuestions[checkIndex].question == questions[buttonIndex[0]] && myQuestions[checkIndex].answer == questions[buttonIndex[1]] || myQuestions[checkIndex].answer == questions[buttonIndex[0]] && myQuestions[checkIndex].question == questions[buttonIndex[1]] {
                    isCorrect = true
                }
                checkIndex += 1
            }
        
            if isCorrect == false {
                setDisplayButtonTimer()
            }
            
        } else {
           pressedTimes += 1
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.baseballImageView.isHidden = false
            self.view.bringSubviewToFront(self.baseballImageView)
            
            self.baseballImageView.frame = self.baseballImageView.frame.offsetBy(dx: self.CGPoints[button].x-180-CGFloat(200/level/2), dy: self.CGPoints[button].y-950+CGFloat(200/level/2))
        }
        animator.startAnimation()
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { timer in
            self.baseballImageView.frame = self.baseballImageView.frame.offsetBy(dx: -self.CGPoints[button].x+180+CGFloat(200/level/2), dy: -self.CGPoints[button].y+950-CGFloat(200/level/2))
        }
    }
    
   
    @IBAction func changeColumns(_ sender: UIButton) {
        resultView.alpha = 0
        CGPoints.removeAll()
        totalProgressValue = 1
        setSeconds()
        countDown()
        
        if sender == preButton {
            if level > 1 {
                preButton.isEnabled = true
                buttons.removeAll()
                if let columnView = columnViews.first {
                    columnView.removeFromSuperview()
                    columnViews.removeAll()
                }
                level -= 1
                makeBlocks()
            } else {
                preButton.isEnabled = false
            }
        } else if sender == nextButton {
            if level < 5 {
                nextButton.isEnabled = true
                buttons.removeAll()
                if let columnView = columnViews.first {
                    columnView.removeFromSuperview()
                    columnViews.removeAll()
                }
                level += 1
                makeBlocks()
            } else {
                nextButton.isEnabled = false
            }
        } else {
            buttons.removeAll()
            if let columnView = columnViews.first {
                columnView.removeFromSuperview()
                columnViews.removeAll()
            }
            makeBlocks()
        }
        
       levelLabelString = "\(level)"
    }
    
    @IBAction func backToMenu(_ sender: Any) {
        countDownTimer?.invalidate()
    }
    
}
