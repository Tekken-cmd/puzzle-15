//
//  BoardView.swift
//  Puzzle 15
//
//  Created by Atakhanov Akbarjon on 2020/07/04.
//  Copyright © 2020 Tekken. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var trueTags = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] // change position each time you move
    var falseTags = [17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32] // maintains initial position
    var trueTileArray: [UIView] = []
    var falseTileArray: [UIView] = []
    
    //needed when initializing views in Storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTile()
        createFalseTile()
    }
    //needed when programmatically initializing views
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createTile()
        createFalseTile()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        positionTiles(array: trueTags)
    }
    
    //MARK: - Manage Position
    
    // pass the return value to the buttonPressed
    func shuffleArray() -> [Int] {
        trueTags.shuffle()
        return trueTags
    }
    // shuffle and then position the tiles once the "shuffle" button is pressed
    func positionTiles(array: [Int]) {
        let widthDif = Int(self.frame.width) // board's width
        let heightDif = Int(self.frame.height) // board's height
        var x = 8 // origin.x
        var y = 8 // origin.y
        var t = 0 // position of the array element
        
        for _ in 0...3 {
            for _ in 0...3 {
                guard let tile = self.viewWithTag(array[t]) else {
                    return
                }
                tile.frame = CGRect(x: x, y: y, width: 80, height: 80)
                trueTileArray.append(tile)
                x += heightDif / 4
                t += 1
            }
            y += widthDif / 4
            x = 8
        }
    }
    
    func createTile() {
        self.layer.cornerRadius = 15
        
        for i in 1...16 {
            let tile = UIButton()
            tile.backgroundColor = .orange
            tile.layer.cornerRadius = 20
            tile.setTitle("\(i)", for: .normal)
            tile.setTitleColor(.white, for: .normal)
            tile.titleLabel?.font = UIFont .systemFont(ofSize: 25)
            tile.tag = i
            tile.addTarget(self, action: #selector(tileAction), for: .touchUpInside)
            addSubview(tile)
            
            
        }
        guard let tile = self.viewWithTag(16) else {
            return
        }
        
        tile.isHidden = true
        
    }
    // create false tile behind the original ones to save the tile's initial sorted position (coordinates)
    func createFalseTile() {
        for i in 17...32 {
            let falseTile = UIButton()
            falseTile.tag = i
            addSubview(falseTile)
            falseTile.isHidden = true
        }
        
        let widthDif = Int(self.frame.width) // board's width
        let heightDif = Int(self.frame.height) // board's height
        var x = 8 // origin.x
        var y = 8 // origin.y
        var t = 0 // position of the array element
        
        for _ in 0...3 {
            for _ in 0...3 {
                guard let tile = self.viewWithTag(falseTags[t]) else {
                    return
                }
                tile.frame = CGRect(x: x, y: y, width: 80, height: 80)
                falseTileArray.append(tile)
                x += heightDif / 4
                t += 1
            }
            y += widthDif / 4
            x = 8
        }
    }
    
    //MARK: - Movement Check
    
    @objc func tileAction(sender: UIButton!) {
        let tile16 = self.viewWithTag(16)!
        guard let tile = sender else { return };
        
        move(tile: tile, tile16: tile16)
        
        if winCheck() {
            let alert = UIAlertController(title: "You won!", message: "Perfect!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Play again", style: UIAlertAction.Style.default, handler: .some({ (UIAlertAction) in
                self.positionTiles(array: self.shuffleArray())
            })))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // check and move if the tile can be moved to any of the four directions (rigth, left, up and down)
    func move(tile: UIButton, tile16: UIView) {
        let emptyTileY = tile16.frame.origin.y
        let emptyTileX = tile16.frame.origin.x
        let spaceDif = CGFloat(93) // difference between the current tile's X value to the empty tile's X value
        
        if tile.center.x == tile16.center.x {
            if (tile.frame.origin.y + spaceDif) == tile16.frame.origin.y {
                tile16.frame.origin.y = tile.frame.origin.y
                tile.frame.origin.y = emptyTileY
            } else if (tile.frame.origin.y - spaceDif) == tile16.frame.origin.y {
                tile16.frame.origin.y = tile.frame.origin.y
                tile.frame.origin.y = emptyTileY
            }
        } else if tile.center.y == tile16.center.y {
            if (tile.frame.origin.x + spaceDif) == tile16.frame.origin.x {
                tile16.frame.origin.x = tile.frame.origin.x
                tile.frame.origin.x = emptyTileX
            } else if (tile.frame.origin.x - spaceDif) == tile16.frame.origin.x {
                tile16.frame.origin.x = tile.frame.origin.x
                tile.frame.origin.x = emptyTileX
            }
        }
    }
    //MARK: - Winner Check
    
    // check if the current position of tiles matches the initial "winner/sorted" position
    func winCheck() -> Bool {
        var flag = false
        var a: [CGRect] = [] // to save the the initial (x,y) coordinates
        var b: [CGRect] = [] // to save the current/changed (x,y) coordinates
        
        for i in 0...15 {
            a.append(falseTileArray[i].frame)
            b.append(trueTileArray[i].frame)
        }
        if a == b {
            //            print("You won!")
            flag = true
        }
        return flag
    }
    
}
