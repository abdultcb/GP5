//
//  ViewController.swift
//  Surya
//
//  Created by Abdul Yasin on 21/02/19.
//  Copyright © 2019 Abdul Yasin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailContainerView: PopView!
    @IBOutlet weak var emailTextField: UITextField!
    
    lazy var viewModel: PersonViewModel = {
        let vm = PersonViewModel()
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        viewModel.checkForLocalData()
    }
    
    
    
    /// Data binding in case view model wants to communicat eback with View
    private func  bindData() {
        viewModel.loadData = {
            DispatchQueue.main.async {
                self.showTableView()
                self.tableView.reloadSections([0], with: .top)
            }
        }
    }
    
    // MARK:- SUBMIT
    
    
    /// Submit Email ID and hit a post request to get a list of people associated with that email address
    ///
    /// - Parameter sender: sender
    @IBAction func submitBtnAction(_ sender: UIButton) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      
        if email.isEmpty == true || email.count == 0 {
            showAlert("Empty Email address")
            return
        }
        
        if isValidEmail(email) == false {
            showAlert("Invalid Email address")
            return
        }

        
        // Proceed to fetch Lists for that emai address
        viewModel.fetchList(email)
        
    }
    
    private func showTableView() {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.35
        emailContainerView.layer.add(transition, forKey: kCATransition)
        
        emailContainerView.isHidden = true
        tableView.isHidden = false
    }
    
    private func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)

    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.id, for: indexPath) as! PersonTableViewCell
        
        let item = viewModel.itemForRowAt(indexPath)
        cell.firstNameLabel.text = item.firstName
        cell.lastNameLabel.text = item.lastName
        cell.emailIDLabel.text = item.email
//        cell.profileImageView.image = item.profilePhoto
        return cell
    }
    
    
}

