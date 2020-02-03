//
//  itemVC.swift
//  foodApp
//
//  Created by pop on 2/2/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class itemVC: UIViewController {
    var chosenItem = mealitem()
    var orderitem = order()
    var delegate : orderdata?
    @IBOutlet weak var itemimage: UIImageView!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var itemprice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureitem()
    }
    
    func configureitem(){
        itemname.text = chosenItem.name
        itemprice.text = chosenItem.price
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL: chosenItem.photourl!)
        reference.downloadURL(completion: { (url, error) in
            let data = NSData(contentsOf: url!)
           let image2 = UIImage(data: data! as Data)!
           self.itemimage.image = image2
    }
    )}
    @IBAction func addBTN(_ sender: Any) {
        orderitem.name = chosenItem.name
        orderitem.price = Int(chosenItem.price!)
        delegate?.getdata(data: orderitem)
        navigationController?.popViewController(animated: true)
    }
    
}


protocol orderdata {
    func getdata(data:order)
}
