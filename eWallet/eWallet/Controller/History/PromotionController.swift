//
//  HistoryTopupViewController.swift
//  eWallet
//
//  Created by chain'rong KST on 15/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct promoData {
    let imgPromo : UIImage!
    let name : String!
    let detail: String!
}

class PromotionController:  UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var UserType : Int!
    var db = Firestore.firestore()
    var WID : String = ""
    var countarr = [promoData]()
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        countarr = [
            promoData(imgPromo: UIImage(named: "javier-garcia-186629"),name: "Promotion", detail: "Details"),
                promoData(imgPromo: UIImage(named: "javier-garcia-186629"),name: "Promotion", detail: "Details"),
                promoData(imgPromo: UIImage(named: "javier-garcia-186629"),name: "Promotion", detail: "Details"),
                promoData(imgPromo: UIImage(named: "javier-garcia-186629"),name: "Promotion", detail: "Details")]
        
        self.tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("PromotionViewCell", owner: self, options: nil)?.first as! PromotionViewCell
        cell.proImg.image = countarr[indexPath.row].imgPromo
        cell.nameLabel.text = countarr[indexPath.row].name
        cell.detailsLabel.text = countarr[indexPath.row].detail
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
}

