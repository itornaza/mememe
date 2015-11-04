//
//  MemeTable.swift
//  meme
//
//  Created by Ioannis Tornazakis on 24/3/15.
//  Copyright (c) 2015 polarbear.gr. All rights reserved.
//

import Foundation
import UIKit

class MemeTable: UITableViewController {
    
    // MARK: - Model
    
    var memes: [Meme]!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the meme data from the AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        // If there are no images, goto the Edit Memes without implying 
        // any animation
        if (memes.count == 0) {
            // Modally present the Meme editor:
            self.switchToEditMode(false)
        } else {
            // Reload the table data only if there are one memes or more
            tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func EditMeme(sender: AnyObject) {
        // Modally present the Meme editor
        self.switchToEditMode(true)
    }
    
    // MARK: - Table View Delegate
    
    /**
        Number of rows
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    /**
        Cell for row at index path
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 1. Dequeue a reusable cell from the table, using the correct “reuse identifier”
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")! as UITableViewCell
        
        // 2. Find the model object that corresponds to that row
        let sentMemeForRow = self.memes[indexPath.row]

        // 3. Set the images and labels in the cell with the data from the model object
        cell.textLabel?.text = sentMemeForRow.topText + "..." + sentMemeForRow.bottomText
        cell.imageView?.image = sentMemeForRow.memedImage
        
        // 4. return the cell
        return cell
    }

    /**
        Detail view
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Grab the detail controller from the storyboard
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetails") as! MemeDetails
        // Assign the meme at index
        detailController.meme = self.memes[indexPath.row]
        // Go to the detail view
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: - Segues
    
    func switchToEditMode(animation: Bool) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            // Grab storyboard
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            // Get the destination controller from the storyboard id
            let nextVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditor
            // Go to the destination controller
            self.presentViewController(nextVC, animated: animation, completion: nil)
        }
    }

}
