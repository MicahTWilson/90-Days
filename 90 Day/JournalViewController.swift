//
//  JournalViewController.swift
//  90 Day
//
//  Created by Micah Wilson on 8/20/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var journalView: UIView!
    @IBOutlet weak var progressView: MWProgressView!
    @IBOutlet weak var textView: MWTextView!
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var campaign: Course!
    var currentDate: NSDate!
    var journal: Journal?
    var editingJournal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var progress = 0
        for goal in self.campaign!.challenges.allObjects as! [Challenge] {
            for (index, dayComplete) in enumerate(goal.daysCompleted.allObjects as! [CompletionProgress]) {
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let completed = dayComplete.dateCompleted {
                    if dateFormatter.stringFromDate(dayComplete.dateCompleted!) == dateFormatter.stringFromDate(self.currentDate) {
                        //Goal has been completed. Update Count.
                        progress++
                    }
                }
            }
        }
        
        if let jrnl = self.journal {
            self.editingJournal = true
            self.textView.text = jrnl.entry
        }
        
        self.progressView.value = Double(progress)
        self.progressView.endingValue = Double(self.campaign.challenges.count)
        self.progressView.setNeedsDisplay()
        
        self.textView.becomeFirstResponder()
        
        self.textView.setNeedsDisplay()
    }
    
    @IBAction func cancelJournal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePressed(sender: UIButton) {
        if editingJournal {
            self.journal!.entry = self.textView.text
            self.appDel.managedObjectContext!.save(nil)
        } else {
            var error: NSError?
            Journal.addJournal(self.textView.text, entryDate: self.currentDate, campaign: self.campaign, context: appDel.managedObjectContext!, error: &error)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TextView Delegate Methods
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.journalView.transform = CGAffineTransformMakeTranslation(0, -50)
        })
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.journalView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
}
