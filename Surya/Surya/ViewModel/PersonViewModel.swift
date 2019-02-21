//
//  PersonViewModel.swift
//  Surya
//
//  Created by Abdul on 21/02/19.
//  Copyright © 2019 VirtualEmployee. All rights reserved.
//

import UIKit

protocol PersonViewModelProtocol {
    func numberOfRows() -> Int
    func itemForRowAt(_ indexPath: IndexPath) -> PersonCellView
    
}
class PersonViewModel: NSObject {
    private var items = [Person]()
    let networkManager = NetworkManager.shared

    struct Keys {
        static let isDataAvailableLocally = "is_data_available"
        static let localData = "local_data"
    }
    
    // Data binders
    var loadData: (() -> Void)?
    
    func fetchList(_ email: String) {
        // Fetch Fresh data from network (Server)
        var parameter = [String : Any]()
        parameter["emailId"] = email
        
        networkManager.startRequest("POST", params: parameter) { (data, error) in
            
            if error != nil {
                print("Error in request: \(String(describing: error?.localizedDescription))")
            }
            
            // Parse response
            if let payload = data {
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(Result.self, from: payload) {
                    self.items = result.items
                    
                    // Cache Data Locally
                    self.saveDataLocally()
                    
                    // Notify view to load data
                    self.loadData?()
                }
                
            }

        }
        
    }
    
    func checkForLocalData() {
        // Check for any saved local data
        if let results = self.fetchLocalData() {
            self.items = results
            loadData?()
        }

    }
    
    
    private func saveDataLocally() {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(self.items)
        
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: Keys.localData)
        defaults.set(true, forKey: Keys.isDataAvailableLocally)
        defaults.synchronize()
    }
    
    private func fetchLocalData() -> [Person]? {
        let defaults = UserDefaults.standard
        let dataAvailable = defaults.bool(forKey: Keys.isDataAvailableLocally)
        
        if dataAvailable == true {
            
            if let data = defaults.object(forKey: Keys.localData) as? Data {
                let decoder = JSONDecoder()
                let persons = try? decoder.decode([Person].self, from: data)
                return persons
            }
            
        }
        
        return nil
    }
}

extension PersonViewModel: PersonViewModelProtocol {
    func numberOfRows() -> Int {
        return items.count
    }
    
    func itemForRowAt(_ indexPath: IndexPath) -> PersonCellView {
        let item = items[indexPath.row]
        return PersonCellView(firstName: item.firstName,
                              lastName: item.lastName,
                              email: item.email,
                              profilePhoto: item.profilePhoto)
        
    }

}

struct PersonCellView {
    var firstName: String
    var lastName: String
    var email: String
    var profilePhoto: String

}
