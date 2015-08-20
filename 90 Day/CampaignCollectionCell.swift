//
//  CampaignCollectionCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class CampaignCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var campaignLengthLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    var campaign: Course!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaign.challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let goalCell = tableView.dequeueReusableCellWithIdentifier("goalCell") as! GoalTableCell
        goalCell.goalTitleLabel.text = (campaign.challenges.allObjects as! [Challenge])[indexPath.row].task
        
        return goalCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
