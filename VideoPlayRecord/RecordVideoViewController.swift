//
//  RecordVideoViewController.swift
//  VideoPlayRecord
//
//  Created by Daryl Lu on 2/26/15.
//  Copyright (c) 2015 Daryl Lu. All rights reserved.
//

import UIKit

class RecordVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAndPlay(sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            return
        }
        
        var cameraUI: UIImagePickerController = UIImagePickerController()
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        cameraUI.mediaTypes = [kUTTypeMovie!]
        
        cameraUI.allowsEditing = false
        cameraUI.delegate = self
        
        self.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var mediaType: String = info[UIImagePickerControllerMediaType] as String
        self.dismissViewControllerAnimated(false, completion: { // nil)
            
            let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.CompareCaseInsensitive)
            
            if compareResult == CFComparisonResult.CompareEqualTo {
                let moviePath = info[UIImagePickerControllerMediaURL] as NSURL
                
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath.relativePath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(moviePath.relativePath, self, "video:didFinishSavingWithError:contextInfo:", nil)
                }
                self.doEdit(moviePath.relativePath!)
            }
            
        })
    }
    
    func video(videoPath: String, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        if error != nil {
            UIAlertView(title: "Error", message: "Video Saving Failed", delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            UIAlertView(title: "Video Saved!", message: "Saved to Photo Album", delegate: nil, cancelButtonTitle: "OK").show()
            
        }
    }
    
    func doEdit(moviePath: String) {
        let vec: UIVideoEditorController = UIVideoEditorController()
        vec.videoPath = moviePath
        vec.delegate = self
        
        self.presentViewController(vec, animated: true, completion: nil)
    }
    
    func videoEditorControllerDidCancel(editor: UIVideoEditorController) {
        println("User cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func videoEditorController(editor: UIVideoEditorController, didFailWithError error: NSError) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
