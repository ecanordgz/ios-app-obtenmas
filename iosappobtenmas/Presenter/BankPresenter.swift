//
//  BankData.swift
//  iosappobtenmas
//
//  Created by Enrique Cano on 22/05/23.
//

import Foundation

protocol UI: AnyObject {
    func update()
}

final class BankPresenter {
    weak var delegate: UI?
    
    var banks: [Bank] = []
    
    private var bankData = BankData()
    
    func getBanks() {
        let banksFromDb = bankData.getBanksFromDb()
        
        if banksFromDb.count == 0 {
            bankData.getBanksFromService(completionBlock: { (banksResult) in
                for bankItem in banksResult {
                    self.bankData.createBankInDb(bank: bankItem)
                }
                self.banks = banksResult
                self.delegate?.update()
            })
        } else {
            self.banks = banksFromDb
            delegate?.update()
        }
    }
    
    func removeAllBanks() {
        bankData.removeAllBanksFromDb()
    }
}
