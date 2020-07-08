//
//  ViewController.swift
//  Puzzle 15
//
//  Created by Atakhanov Akbarjon on 2020/07/04.
//  Copyright © 2020 Tekken. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 15
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.setTitle("Restart", for: .normal)
        boardView.positionTiles(array: boardView.shuffleArray())
        
    }
    
    
   
    
}

