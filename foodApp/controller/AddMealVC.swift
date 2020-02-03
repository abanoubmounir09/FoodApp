//
//  AddMealVC.swift
//  foodApp
//
//  Created by pop on 2/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddMealVC: UIViewController {

    @IBOutlet weak var myimageMeal: UIImageView!
    @IBOutlet weak var nametxtf: UITextField!
    @IBOutlet weak var pricetxtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mygesture = UITapGestureRecognizer(target: self, action: #selector(handleimage))
        myimageMeal.isUserInteractionEnabled = true
        myimageMeal.addGestureRecognizer(mygesture)
    }
    
    
    
    //ADD :- button for meal
    @IBAction func addBTn(_ sender: Any) {
        SVProgressHUD.show()
        let imagename = NSUUID().uuidString
        let storage = FIRStorage.storage().reference().child("image-name").child("\(imagename).jpg")
        if let uploaddata = UIImageJPEGRepresentation(myimageMeal.image!, 0.1){
            storage.put(uploaddata, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error)
                    return
                }else{
                    let imageurl = metadata?.downloadURL()?.absoluteString
                    print("photo saved")
                    self.addmeal(imageurl: imageurl!)
                }
            })
        }
        
        
    }// end : - btn
    
    func addmeal(imageurl : String){
        let database = FIRDatabase.database().reference().child("meal").childByAutoId()
        guard let mealname = nametxtf.text, nametxtf.text != nil else{return}
        guard let price =  pricetxtf.text, pricetxtf.text != nil else{return}
        let params = ["name":mealname,"price":price,"urlimage":imageurl]
        //let params2 = ["name":mealname,"price":price]
        database.setValue(params) { (error, data) in
            if error != nil{
                print(error)
                return
            }else{
                SVProgressHUD.dismiss()
                print("succes saved meal")
            }
        }
    }
    

}


extension AddMealVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func handleimage(){
        print("123")
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        imagepicker.allowsEditing = false
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        myimageMeal.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}














