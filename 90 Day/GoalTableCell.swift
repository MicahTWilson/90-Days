//
//  GoalTableCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/19/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit

class GoalTableCell: UITableViewCell {
    @IBOutlet weak var goalTitleLabel: UITextField!
    @IBOutlet weak var completedImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}