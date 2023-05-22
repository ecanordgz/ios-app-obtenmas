//
//  ViewController.swift
//  iosappobtenmas
//
//  Created by Enrique Cano on 22/05/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UI, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var banksTableView: UITableView!
    
    private var bankPresenter = BankPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.banksTableView.dataSource = self
        self.banksTableView.delegate = self
        self.bankPresenter.delegate = self
        
        // Use for test of service
        //self.bankPresenter.removeAllBanks()
        
        self.bankPresenter.getBanks()
    }
    
    func update() {
        DispatchQueue.main.async {
            self.banksTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankPresenter.banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bankCell = self.banksTableView.dequeueReusableCell(withIdentifier: "bankCell", for: indexPath) as! BankTableViewCell
        
        DispatchQueue.global().async { [weak self] in
            guard let imageString = self!.bankPresenter.banks[indexPath.row].url else {
                return
            }
            
            guard let url = URL(string: imageString) else {
                return
            }
            
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        bankCell.logoImageView.image = image
                    }
                }
            }
        }
        
        bankCell.nameLabel.text = self.bankPresenter.banks[indexPath.row].bankName
        bankCell.descriptionLabel.text = self.bankPresenter.banks[indexPath.row].description
        bankCell.ageLabel.text = self.bankPresenter.banks[indexPath.row].age?.description
        
        return bankCell
    }

}

