//
//  myCell.swift
//  Instagram
//
//  Created by Xiangrui on 3/1/15.
//  Copyright (c) 2015 Xiangrui. All rights reserved.
//

import UIKit

class cell: UITableViewCell {
    
    
    
    
    @IBAction func comments(sender: UITextField) {
        
    }
    
    
    @IBOutlet var postedImage: UIImageView!
    

    @IBOutlet var myText: UILabel!
    
    func fillCell(id: String, username: String,title: String,file: PFFile, comment:Array<String>){
        println(id)
        myText.text = username + ": " + title
        file.getDataInBackgroundWithBlock({
            (imageData:NSData!,error:NSError!) in
            if (error == nil){
                let image = UIImage(data:imageData)
                self.postedImage.image = image
            }
        })
    
        /*var myLabel = UILabel(frame: CGRectMake(15, 255, 200, 40))
        myLabel.font = UIFont(name: "System", size:10)
        myLabel.text = "this is a \ntest label"
        myLabel.numberOfLines = 0
        self.addSubview(myLabel)*/
        
        
    }
    
}
