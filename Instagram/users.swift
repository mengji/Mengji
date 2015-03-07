//
//  users.swift
//  Instagram
//
//  Created by Xiangrui on 3/1/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIkit

class users: UITableViewController {
    
    
    var users = [String]()
    //var follow = [Bool]()
    var follow = Dictionary<String,Bool>()
    
    var refresher:UIRefreshControl!
    
    //log out button
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout",sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUsers()
        //add the refresher to the view
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    //get data from database
    func updateUsers(){
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            self.users.removeAll(keepCapacity: true)
            
            //get other users in database
            for object in objects {
                var user:PFUser = object as PFUser
                var isFollowing:Bool
                if user.username != PFUser.currentUser().username {
                    self.users.append(user.username)
                    isFollowing = false
                    var query = PFQuery(className:"followers")
                    query.whereKey("follower", equalTo:PFUser.currentUser().username)
                    query.whereKey("following", equalTo:user.username)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            for object in objects {
                                isFollowing = true
                            }
                            self.follow[user.username] = isFollowing
                            self.tableView.reloadData()
                        } else {
                            // Log details of the failure
                            println(error)
                        }
                        //refresher stops after updating complete
                        self.refresher.endRefreshing()
                    }
                }
            }
        })
    }
    
    func refresh(){
        updateUsers()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //add users name to every cell and check if followed
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell :UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = users[indexPath.row]
        if follow.count != 0 && follow.indexForKey(users[indexPath.row]) != nil{
            if follow[users[indexPath.row]] == true{
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        return cell
        
    }
    
    //If a cell is clicked, check if its followed and make checkmark appear properly
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell :UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        if (cell.accessoryType == UITableViewCellAccessoryType.Checkmark){
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.whereKey("following", equalTo: cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock({
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if error == nil{
                    for object in objects {
                        object.deleteInBackgroundWithBlock {
                            (success: Bool, error: NSError!) -> Void in
                            if (success) {
                                // The object has been saved.
                            } else {
                                // There was a problem, check error.description
                            }
                        }
                    }
                }
            })
        } else{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            var following = PFObject(className: "followers")
            following.setValue(PFUser.currentUser().username, forKey: "follower")
            following.setValue(cell.textLabel?.text, forKey: "following")
            following.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        }
    }
    
    
    
    

}
