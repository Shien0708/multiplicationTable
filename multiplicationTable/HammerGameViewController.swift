//
//  HammerGameViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/14.
//

import UIKit

var playerCount = 1

class HammerGameViewController: UIViewController {
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var hammers: [UIImageView]!
    
    @IBOutlet weak var ballImageView: UIImageView!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var readyView: UIView!
    @IBOutlet weak var playerNumLabel: UILabel!
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    var second = 0
    var questionIndex = 0
    var answerIndex = Int.random(in: 0...2)
    var timer: Timer?
    var arrowTimer: Timer?
    var hammerTimer: Timer?
    var animator: UIViewPropertyAnimator?
    var hammerAnimator: UIViewPropertyAnimator?
    var arrowAnimator: UIViewPropertyAnimator?
    var playerNum = 1
    var triangleViews = [UIView]()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradientView()
        playAgainButton.isHidden = true
        playerNumLabel.text = "1"
        backgroundImageView.image = UIImage.animatedImageNamed("amusement2-", duration: 10)
        
    }
    
    @IBAction func go(_ sender: Any) {
        makeQuestions()
        showCurrentQuestion()
        readyView.isHidden = true
    }
    
    
    func makeATriangle(y: Float, player: Int){
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: 80, height: 20))
        label.text = "Player \(player)"
        label.font = UIFont(name: "Marker Felt", size: 20)
        label.textColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 80, y: 0))
        trianglePath.addLine(to: CGPoint(x: 80, y: 40))
        trianglePath.addLine(to: CGPoint(x: 100, y: 20))
        trianglePath.close()
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.lineWidth = 2
        triangleLayer.fillColor = label.textColor.cgColor
        
        let triangleView = UIView()
        triangleView.frame = CGRect(x: CGFloat(50), y: CGFloat(y), width: CGFloat(120), height: CGFloat(20))
        triangleView.backgroundColor = .clear
        triangleView.layer.addSublayer(triangleLayer)
        
        triangleViews.append(triangleView)
        
        triangleView.addSubview(label)
        view.addSubview(triangleView)
        view.bringSubviewToFront(triangleView)
    }
    
    
    func makeGradientView(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 36, height: 300)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func moveArrow(){
        
        arrowTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { arrowTimer in
            self.arrowAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                self.second += 1
                self.arrowImageView.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.second)*60*0.1)
            })
            
            if self.second == 50 {
                self.arrowTimer?.invalidate()
                self.resultView.isHidden = false
                self.view.bringSubviewToFront(self.resultView)
            } else {
                self.arrowAnimator?.startAnimation()
            }
        })
    }
    
    func makeQuestions(){
        myQuestions.removeAll()
        for _ in 0...playerCount-1 {
            let num1 = Int.random(in: 1...9)
            let num2 = Int.random(in: 1...9)
            myQuestions.append(Question(question: "\(num1) X \(num2)", answer: "\(num1*num2)"))
        }
    }
    
    func showCurrentQuestion() {
        
        moveArrow()
        
        for i in 0...hammers.count-1 {
            hammers[i].isHidden = true
            buttons[i].isHidden = false
        }
        
        answerIndex = Int.random(in: 0...2)
        
        questionLabel.text = myQuestions[questionIndex].question
        
        for i in 0...2 {
            if answerIndex == i {
                buttons[i].setTitle(myQuestions[questionIndex].answer, for: .normal)
            } else {
                buttons[i].setTitle(String(Int(myQuestions[questionIndex].answer)!+Int.random(in: 1...10)), for: .normal)
            }
        }
    }
    
    
    @IBAction func hitTheButton(_ sender: UIButton) {
        
        arrowTimer?.invalidate()
        for i in 0...buttons.count-1{
            buttons[i].isHidden = true
            if sender == buttons[i] {
                hammerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { hammerTimer in
                    
                    self.hammerAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                        self.hammers[i].isHidden = false
                    })
                    self.hammerAnimator?.startAnimation()
                })
                
                hammerTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { hammerTimer in
                    self.hammerAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: {
                        
                        self.hammers[i].transform = CGAffineTransform(translationX: 0, y: 50)
                     })
                    self.hammerAnimator?.startAnimation()
                })
            }
        }
        
       
        
        if sender.titleLabel?.text == myQuestions[questionIndex].answer {
            //correct
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
                    self.ballImageView.transform = CGAffineTransform(translationX: 0, y: CGFloat(-10*(50-self.second)))
                    print(self.second)
                }
                self.animator!.startAnimation()
                self.makeATriangle(y: Float(507-(10*(50-self.second))), player: self.playerNum)
                self.resultLabel.text! += "player \(self.playerNum) :   \(10*(50-self.second))points \n\n"
            }
            
           
        } else {
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
                self.animator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
                    self.ballImageView.transform = CGAffineTransform(translationX: 0, y: -20)
                })
                self.animator?.startAnimation()
            })
            
            
            timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
                self.animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
                    self.ballImageView.transform = CGAffineTransform(translationX: 0, y: 0)
                })
                self.animator?.startAnimation()
                self.makeATriangle(y: 507, player: self.playerNum)
                self.resultLabel.text! += "player \(self.playerNum) :   0 point \n\n"
            })
            //wrong
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
            self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {
                self.resultView.isHidden = false
                self.view.bringSubviewToFront(self.resultView)
                
            })
            self.animator?.startAnimation()
        })
        
    }
    
    func reset(){
        for i in 0...hammers.count-1{
            hammers[i].transform = CGAffineTransform(translationX: 0, y: -50)
        }
        
        hammers[answerIndex].isHidden = true
        arrowImageView.transform = CGAffineTransform(translationX: 0, y: 0)
        ballImageView.transform = CGAffineTransform(translationX: 0, y: 0)
    
        second = 0
        
        if playerNum < playerCount {
            playerNum += 1
            playerNumLabel.text = "\(playerNum)"
            if playerNum == playerCount {
                playAgainButton.isHidden = false
            }
        }
    }
    
    
    @IBAction func playAgain(_ sender: Any) {
        reset()
        playerNum = 1
        playerNumLabel.text = "\(playerNum)"
        for i in 0...triangleViews.count-1 {
            triangleViews[i].removeFromSuperview()
        }
        triangleViews.removeAll()
        playAgainButton.isHidden = true
        resultView.isHidden = true
        readyView.isHidden = false
        view.bringSubviewToFront(readyView)
        resultLabel.text = ""
    }
    

    @IBAction func backToGame(_ sender: Any) {
        reset()
        resultView.isHidden = true
        readyView.isHidden = false
        view.bringSubviewToFront(readyView)
    }
    
}
