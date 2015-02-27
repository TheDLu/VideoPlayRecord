//
//  PlayVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Daryl Lu on 2/26/15.
//  Copyright (c) 2015 Daryl Lu. All rights reserved.
//

import UIKit

class PlayVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playVideo(sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            return
        }
        
        var mediaUI: UIImagePickerController = UIImagePickerController()
        mediaUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie!]
        mediaUI.allowsEditing = true
        mediaUI.delegate = self
        
        self.presentViewController(mediaUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var mediaType: String = info[UIImagePickerControllerMediaType] as String
        self.dismissViewControllerAnimated(false, completion: { //nil)
            
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.CompareCaseInsensitive)
            
            if compareResult == CFComparisonResult.CompareEqualTo {
                let theMovie: MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: info[UIImagePickerControllerMediaURL] as NSURL)
                self.presentMoviePlayerViewControllerAnimated(theMovie)
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "myMovieFinishedCallback", name: MPMoviePlayerPlaybackDidFinishNotification, object: theMovie)
            }
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func myMovieFinishedCallBack(aNotification: NSNotification) {
        self.dismissMoviePlayerViewControllerAnimated()
        
        let theMovie: MPMoviePlayerController = aNotification.object as MPMoviePlayerController
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: theMovie)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
