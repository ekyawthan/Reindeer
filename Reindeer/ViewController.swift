//
//  ViewController.swift
//  Reindeer
//
//  Created by Kyaw Than Mong on 9/10/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainContentTableView: UITableView!
    
    var result : [Model] = [] {
        didSet {
            print("data reset")
            self.mainContentTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainContentTableView.delegate = self
        self.mainContentTableView.dataSource = self
        
        // registering cell 
        self.mainContentTableView.registerNib(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        self.mainContentTableView.registerNib(UINib(nibName: "InterestViewCell", bundle: nil), forCellReuseIdentifier: "intCell")
        self.mainContentTableView.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "catCell")
        print("calling")
        NetworkCall(delegate: self)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = self.result[indexPath.row]
        switch(model.dataType){
        case .CAT:
            let cellCat = tableView.dequeueReusableCellWithIdentifier("catCell", forIndexPath: indexPath) as! CategoryCell
            cellCat.categoriesLabel.text = model.categoryName?.name
            return cellCat
        case .INTEREST:
            let cell = tableView.dequeueReusableCellWithIdentifier("intCell", forIndexPath: indexPath) as! InterestViewCell
            cell.interestLabel.text = model.interestedNames?.name
            return cell
            
        case .SEARCH:
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchViewCell
            cell.searchLabel.text = model.searchPharses?.phrase
            return cell
            
        }
        
       
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
}


extension ViewController : callback {
    func onFailed() {
        
    }
    func onSucceed(data: [Model]) {
        print("recieved call back with \(data.count)")
        self.result = data
        
    }
}


