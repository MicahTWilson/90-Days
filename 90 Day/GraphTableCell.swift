//
//  GraphTableCell.swift
//  90 Day
//
//  Created by Micah Wilson on 8/21/15.
//  Copyright (c) 2015 Micah Wilson. All rights reserved.
//

import UIKit
class GraphTableCell: UITableViewCell {
    @IBOutlet weak var graphView: MWGraphView!
    var campaign: Course!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        graphView.campaign = self.campaign
    }
}
