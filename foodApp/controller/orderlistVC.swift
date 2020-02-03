//
//  orderlistVC.swift
//  foodApp
//
//  Created by pop on 2/2/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class orderlistVC: UIViewController {
    var listorder = [order]()
    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var textnumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.delegate = self
        mytableview.dataSource = self
        print(listorder)
    }
    
    @IBAction func getorderBTN(_ sender: Any) {
        SVProgressHUD.show()
        guard let number = textnumber.text,textnumber.text != nil else{return}
        let db = FIRDatabase.database().reference().child("order").child(number).childByAutoId()
        for item in listorder{
            let name = item.name
            let price = item.price
            let parms = ["name":name,"price":price] as [String : Any]
            db.setValue(parms) { (error, ref) in
                if error != nil{
                    print(error)
                    return
                }else{
                    SVProgressHUD.dismiss()
                    print("succes saved order")
                }
                SVProgressHUD.dismiss()
            }
        }
       
    }
    
    func saveitem(){
    }


}


extension orderlistVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listorder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? itemcell
        cell?.nameitem.text = listorder[indexPath.row].name
        if let price = listorder[indexPath.row].price{
            cell?.priceitem.text = String(describing: price)
        }
        
        return cell!
    }
    
    
    
    
}





