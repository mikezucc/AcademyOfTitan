//
//  MasterMindViewController.swift
//  Demo
//
//  Created by cisstudents on 11/18/14.
//  Copyright (c) 2014 cisstudents. All rights reserved.
//

import UIKit

class MasterMindViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate {

    @IBOutlet var slots: [UIPickerView]!
    
    @IBOutlet var correctPositions: UILabel!
    @IBOutlet var correctDigits: UILabel!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var counter: UILabel!
    var maxTime = 60
    
    let pickerData:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var secretcode:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.label.text = ""
        for (index, slot) in enumerate(self.slots) {
            slot.selectRow(8190, inComponent: 0, animated: false)
            self.secretcode.append("\(arc4random_uniform(10))")
            self.label.text = self.label.text! + self.secretcode[index]
        }
    }
    
    func restart()
    {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)
        counter.text = "\(maxTime)"
        self.label.text = ""
        for (index, slot) in enumerate(self.slots) {
            slot.selectRow(8190, inComponent: 0, animated: false)
            self.secretcode.append("\(arc4random_uniform(10))")
            self.label.text = self.label.text! + self.secretcode[index]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func update(sender: NSTimer)
    {
        counter.text = "\(--maxTime)"
        if (maxTime == 0)
        {
            sender.invalidate()
            var alertView:UIAlertView = UIAlertView(title: "NO", message: "out of time!", delegate: self, cancelButtonTitle: "quit", otherButtonTitles: "retry")
            alertView.tag = 1
            alertView.show()
        }
    }
    
    func endGame()
    {
        
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 16384
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerData[row%10]
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView.tag == 0)
        {
            // correct code alert
            if (buttonIndex == 0)
            {
                
            }
            else
            {
                
            }
        }
        else
        {
            
        }
    }

    @IBAction func match(sender: AnyObject) {
        var correct_positions = 0
        var correct_digits = 0
        var code_copy = self.secretcode
        var guess:[String] = []
        var index = 0
        
        for slot in slots {
            var selected = self.pickerData[slot.selectedRowInComponent(0)%10]
            
            if selected == code_copy[index] {
                code_copy.removeAtIndex(index)
                correct_positions++
            }
            else {
                guess.append(selected)
                index++
            }
        }
        
        for digit in guess {
            for index=0; index<code_copy.count; index++ {
                if digit == code_copy[index] {
                    correct_digits++
                    code_copy.removeAtIndex(index)
                }
            }
        }
        if (correct_digits == slots.count)
        {
            var alertView:UIAlertView = UIAlertView(title: "you win", message: "you got the code", delegate: self, cancelButtonTitle: "sweet", otherButtonTitles: "retry")
            alertView.tag = 0
            alertView.show()
        }

        self.correctPositions.text = String(correct_positions)
        self.correctDigits.text = String(correct_digits)
    }
}
