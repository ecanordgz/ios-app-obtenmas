//
//  BankData.swift
//  iosappobtenmas
//
//  Created by Enrique Cano on 22/05/23.
//

import Foundation
import UIKit
import CoreData

final class BankData {
    var banks: [Bank]
        
    let contextDb = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(banks: [Bank] = []) {
        self.banks = banks
    }
    
    func createBankInDb(bank: Bank) {
        do {
            let bankDb = Banks(context: contextDb)
            bankDb.bank_description = bank.description
            bankDb.bank_name = bank.bankName
            bankDb.bank_age = Int32(bank.age ?? 0)
            bankDb.bank_url = bank.url
            try contextDb.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeAllBanksFromDb() {
        do {
            let baksDeleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Banks")
            let banksDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: baksDeleteFetch)
            try contextDb.execute(banksDeleteRequest)
            try contextDb.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getBanksFromDb() -> [Bank] {
        self.banks = []
        
        let banksRequest: NSFetchRequest<Banks> = Banks.fetchRequest()
        do {
            let banks = try contextDb.fetch(banksRequest)
            for bankItem in banks {
                var bank: Bank = Bank()
                bank.bankName = bankItem.bank_name
                bank.description = bankItem.bank_description
                bank.age = Int(bankItem.bank_age)
                bank.url = bankItem.bank_url
                self.banks.append(bank)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return self.banks
    }
    
    func getBanksFromService(completionBlock: @escaping ([Bank]) -> Void) {
        let urlString = "https://dev.obtenmas.com/catom/api/challenge/banks"
        let urlSession = URLSession.shared
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            guard let dataResponse = data else {
                completionBlock(self.banks)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            if let decodedData = try? jsonDecoder.decode([Bank].self, from: dataResponse) {
                if decodedData.count > 0 {
                    self.banks = decodedData
                }
            }
            
            completionBlock(self.banks)
            return
        }.resume()
    }
}
