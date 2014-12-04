//
//  ViewController.swift
//  Demo
//
//  Created by cisstudents on 11/11/14.
//  Copyright (c) 2014 cisstudents. All rights reserved.
//

import UIKit

class WhackAMoleViewController: UIViewController {
    
    @IBOutlet var holes: [UIImageView]!
    @IBOutlet var time: UILabel!
    
    var timelimit = 60
    var lives = 5
    var moles_spawn = 1
    var active_moles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.restart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(sender: NSTimer) {
        time.text = "\(--timelimit)"
        
        if ( lives <= 0 ) {
            sender.invalidate()
            return
        }
        
        if ( timelimit == 0 ) {
            sender.invalidate()
            
            var alert = UIAlertController(title: "Congratulations", message: "You defeated the moles!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                Void in self.restart()
                })
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) {
                Void in self.dismissViewControllerAnimated(true, completion: nil)
            })
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if ( 30 < timelimit && timelimit <= 45) {
            moles_spawn = 2
        }
        else if ( 15 < timelimit && timelimit <= 30) {
            moles_spawn = 3
        }
        else if ( 0 < timelimit && timelimit <= 15) {
            moles_spawn = 4
        }
        
        if ( timelimit % 5 == 0 ) {
            var random = Int(arc4random_uniform(9))
            
            for _ in (1...moles_spawn) {
                while ( active_moles < 9 && holes[random].backgroundColor != UIColor.greenColor() ) {
                    random = Int(arc4random_uniform(9))
                }
                
                if ( active_moles == 9 ) {
                    break
                }
                
                holes[random].backgroundColor = UIColor.yellowColor()
                active_moles++
                NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("moleattack:"), userInfo: random, repeats: false)
            }
        }
    }
    
    func moleattack(sender: NSTimer) {
        var index = sender.userInfo as Int
        
        if ( holes[index].backgroundColor == UIColor.yellowColor() ) {
            holes[index].backgroundColor = UIColor.redColor()

            if ( --lives == 0 ) {
                var alert = UIAlertController(title: "Gameover", message: "Out of lives!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) {
                    Void in self.restart()
                    })
                alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default) {
                    Void in self.dismissViewControllerAnimated(true, completion: nil)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
        }
    }
    
    func restart() {
        for hole in holes {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: "tapHole:")
            tapGesture.numberOfTapsRequired = 2
            
            hole.addGestureRecognizer(tapGesture)
            hole.userInteractionEnabled = true
            hole.backgroundColor = UIColor.greenColor()
        }
        
        timelimit = 60
        lives = 5
        moles_spawn = 1
        active_moles = 0
        time.text = "\(timelimit)"
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
    }
    
    func tapHole(sender: UITapGestureRecognizer) {
        let hole = sender.view?
        
        if ( hole?.backgroundColor == UIColor.yellowColor() ) {
            hole?.backgroundColor = UIColor.greenColor()
            active_moles--
        }
    }
}

