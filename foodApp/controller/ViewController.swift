//
//  ViewController.swift
//  foodApp
//
//  Created by pop on 2/1/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var meals = [mealitem]()
    var mealob = mealitem()
    var recievelist = [order]()
    @IBOutlet weak var mytableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.delegate = self
        mytableview.dataSource = self
        
        fetchmeals()
    }

    @IBAction func menulist(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "orderlist") as? orderlistVC
        vc?.listorder = recievelist
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addpageBTN(_ sender: Any) {
      performSegue(withIdentifier: "gotomealpage", sender: nil)
    }
    
    func fetchmeals(){
        let mydatabase = FIRDatabase.database().reference().child("meal")
        mydatabase.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                self.mealob.name = dict["name"] as? String
                self.mealob.price = dict["price"] as? String
                self.mealob.photourl = dict["urlimage"] as? String
                self.meals.append(self.mealob)
                self.mytableview.reloadData()
                //print("name meal is---------++ \(self.mealob.name)and url is \(self.mealob.photourl)")
            }
        }
    }
    
}


extension ViewController:UITableViewDelegate,UITableViewDataSource,orderdata{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mytableview.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as? itemcell else{return UITableViewCell()}
        var image2 = UIImage()
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = self.meals[indexPath.row].photourl{
                let storage = FIRStorage.storage()
                var reference: FIRStorageReference!
                reference = storage.reference(forURL: url)
                reference.downloadURL(completion: { (url, error) in
                    let data = NSData(contentsOf: url!)
                    image2 = UIImage(data: data! as Data)!
                    cell.imageitem.image = image2
                })
            }
            
        }
        DispatchQueue.main.async {
            cell.nameitem.text = self.meals[indexPath.row].name
            cell.priceitem.text = self.meals[indexPath.row].price
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "itemselected")as? itemVC
        vc?.chosenItem = meal
        vc?.delegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getdata(data: order) {
        recievelist.append(data)
    }
    
    
    
    
    
  /*  func loadImageForcell(url:String)->UIImage{
      /*  if let url = meals[indexPath.row].photourl{
            let storage = FIRStorage.storage()
            var reference: FIRStorageReference!
            reference = storage.reference(forURL: url)
            reference.downloadURL(completion: { (url, error) in
                let data = NSData(contentsOf: url!)
                let image = UIImage(data: data! as Data)
                cell.imageitem.image = image
            })
        }*/
        var image2 = UIImage()
        let storage = FIRStorage.storage()
        var reference: FIRStorageReference!
        reference = storage.reference(forURL: url)
        reference.downloadURL(completion: { (url, error) in
            let data = NSData(contentsOf: url!)
            image2 = UIImage(data: data! as Data)!
           //image2 = image!
      })
        return image2
    }*/
}






