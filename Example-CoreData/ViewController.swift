//
//  ViewController.swift
//  Example-CoreData
//
//  Created by Madhubalan on 14/02/17.
//  Copyright © 2017 RealImages. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //MARK: Outlets
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var pheNoTextField: UITextField!
    @IBOutlet weak var imgeBtn: UIButton!
    
    //MARK: Properties
    
    let picker = UIImagePickerController()
    var flag = 0
    var obId = NSManagedObjectID()
    var isUpdate = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.delegate = self
        self.imgeBtn.layer.cornerRadius = 25.0
    }
    
    //MARK: Actions
    
    @IBAction func saveBtnOnClick(_ sender: UIButton)
    {
        if flag == 0
        {
            if let contactName = self.nameTextField.text, let number = Int64(self.pheNoTextField.text!), let contactPhoto = self.imgeBtn.image(for: .normal)
            {
                let filteredArray = self.fetchFilterFunction(pheNo: number)
                if filteredArray != nil
                {
                    self.showAlertWithTextField(name: contactName, objId: obId)
                }
                else
                {
                    let contactImage = NSData(data: UIImagePNGRepresentation(contactPhoto)!)
                   let obj = ContactDetail.saveDetails(contactName: contactName, contactNo: number, contactPhoto: contactImage)
                     obId = obj.objectID
                    self.showAlert(msg: "Saved Successfully", title : "Confirmation")
                    self.nameTextField.text = ""
                    self.pheNoTextField.text = ""
                    self.imgeBtn.setImage(nil, for: .normal)
                    if (self.nameTextField.text?.isEmpty)!
                    {
                        self.showAlert(msg: "Please enter name", title : "Oops")
                    }
                    else if (self.pheNoTextField.text?.isEmpty)!
                    {
                        self.showAlert(msg: "Please enter PhoneNumber", title : "Oops")
                    }
                    else
                    {
                        self.showAlert(msg: "Please select a photo", title: "Oops")
                    }
                    
                }
            }
            else
            {
                if ((self.nameTextField.text?.isEmpty)! || (self.pheNoTextField.text?.isEmpty)! || (self.imgeBtn.image(for: .normal)) == nil)
                {
                    self.showAlert(msg: "Please enter the valid fields", title : "Oops")
                }
            }
            
        }
        else
        {
            self.nameTextField.text = ""
            self.pheNoTextField.text = ""
            self.imgeBtn.setImage(nil, for: .normal)
            self.saveBtn.setTitle("Save", for: .normal)
            flag = 0
        }
        
    }
    
    
    
    @IBAction func chooseImageBtnOnClick(_ sender: UIButton)
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func findBtnOnClick(_ sender: UIButton)
    {
        if flag == 0
        {
            if (self.pheNoTextField.text?.isEmpty)!
            {
                self.showAlert(msg: "Please enter the valid fields", title : "Oops")
            }
            else if let pheNo = self.pheNoTextField.text
            {
                let filteredContacts = self.fetchFilterFunction(pheNo: Int64(pheNo)!)
                if let pheNumber = filteredContacts?.phoneNo, let name = filteredContacts?.name, let contactPhoto = filteredContacts?.contactPhoto
                {
                    self.nameTextField.text = name
                    self.pheNoTextField.text = String(pheNumber)
                    self.imgeBtn.setImage(UIImage(data : contactPhoto as Data, scale : 1.0), for: .normal)
                    self.saveBtn.setTitle("Clear", for: .normal)
                    flag = 1
                }
                else
                {
                    self.showAlert(msg: "No Contact exists", title: "Oops")
                }
            }
            else
            {
                self.showAlert(msg: "Please Enter the PhoneNumber", title: "Oops")
            }
        }
        
    }
    
    func fetchFilterFunction(pheNo : Int64) -> ContactDetail?
    {
        let contactDetails = ContactDetail.fetchDetails(pheNo : pheNo)
        return contactDetails
    }
    
    //MARK: Helper Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgeBtn.layer.cornerRadius = 25.0
        self.imgeBtn.setImage(chosenImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(msg : String, title : String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            action -> Void in
        })
        self.present(alertController, animated: true)
        {}
    }
    func showAlertWithTextField(name : String, objId : NSManagedObjectID)
    {
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to override the contact name", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Override", style: UIAlertActionStyle.default)
        {
            action -> Void in
            self.isUpdate =  ContactDetail.updateContent(name: name, contactObj: objId)
            if self.isUpdate == true
            {
               self.showAlert(msg: "Updated Successfully", title: "Success")
                self.nameTextField.text = ""
                self.pheNoTextField.text = ""
                self.imgeBtn.setImage(nil, for: .normal)
            }
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        {
            action -> Void in
        })
        self.present(alertController, animated: true)
        {}
    }
}

