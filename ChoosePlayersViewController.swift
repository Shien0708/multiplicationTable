//
//  ChoosePlayersViewController.swift
//  multiplicationTable
//
//  Created by 方仕賢 on 2022/2/15.
//

import UIKit

class ChoosePlayersViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playerCountLabel: UILabel!
    
    @IBOutlet weak var playerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage.animatedImageNamed("hammerGameGif-", duration: 2)
    }
    
    @IBAction func changePlayerCount(_ sender: UIStepper) {
        playerCount = Int(sender.value)
        
        
        playerCountLabel.text = "\(playerCount)"
        
        if playerCount == 1 {
            playerLabel.text = "Player"
        } else {
            playerLabel.text = "Players"
        }
    }
    

    @IBAction func backToChoosePage(segue: UIStoryboardSegue) {
        
    }
    
}
