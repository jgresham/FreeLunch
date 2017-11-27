//
//  FirstViewController.swift
//  FreeLunch
//
//  Created by Johns Gresham on 11/25/17.
//  Copyright © 2017 Johns Gresham. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate  {
    
    //MARK: Properties
    @IBOutlet weak var loginWithRobinhoodBtn: UIButton!
    @IBOutlet weak var loginStatusText: UILabel!
    @IBOutlet weak var loginStatusTextView: UITextView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let defaults = UserDefaults.standard
    let TOKEN_KEY = "token"
    var orders = [RobinhoodOrder]()
    
    //MARK: Private Methods
    private func login() {
        // Get Orders using token
        let userToken = self.defaults.string(forKey: self.TOKEN_KEY)
        print("usertoken in login \(userToken!)")
        let json: [String: Any] = [:]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://api.robinhood.com/orders/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token \(userToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error getting robinhood orders =\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                guard let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                    return
                }
                
                print("responseData: \(responseData)")
                
                if let orders = responseData["results"] as? [[String: AnyObject]] {
                    print("Orders for Robinhood account: \(orders).")
                    DispatchQueue.main.async {
                        self.setLoginStatusText(text: "")
                    }
                    for order in orders {
                        if let price = order["average_price"] as? String {
                            DispatchQueue.main.async {
                                self.setLoginStatusText(text: self.loginStatusTextView.text! + price)
                            }

                        } else {
                            print("Unable to get an order price.")
                        }
                    }
                } else {
                    print("Error getting orders for Robinhood account.")
                    if let responseDetails = responseData["detail"] {
                        print("Error with Robinhood orders: \(responseDetails).")
                        
                    } else {
                        print("Unable to get error description for orders error.")
                    }
                }
                
            } catch let error as Error {
                print(error.localizedDescription)
            }
            
            
            
        }
        task.resume()
    }
    
    private func enableBtn() {
        self.loginWithRobinhoodBtn.isEnabled = true
    }
    private func setLoginStatusText(text: String) {
        self.loginStatusTextView.text = text
    }
    private func loadSampleOrders() {
        guard let order1 = RobinhoodOrder(orderDate: Date(), side: "Buy", price: "10", instrument: "AAPL", quantity: "1") else {
            fatalError("Unable to instantiate order1")
        }
        
        guard let order2 = RobinhoodOrder(orderDate: Date(), side: "Buy", price: "20", instrument: "GOOG", quantity: "2") else {
            fatalError("Unable to instantiate order2")
        }
        
        guard let order3 = RobinhoodOrder(orderDate: Date(), side: "Sell", price: "30", instrument: "CSCO", quantity: "1") else {
            fatalError("Unable to instantiate order3")
        }
        
        orders += [order1, order2, order3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userToken = self.defaults.string(forKey: self.TOKEN_KEY)
        if userToken != nil {
            loginWithRobinhoodBtn.isEnabled = false
            self.login()
        }
        // Handle the text field’s user input through delegate callbacks.
        loginStatusTextView.text = userToken
        print(userToken)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Load sample data
        loadSampleOrders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        loginStatusTextView.text = textField.text
    }
    //MARK: Actions
    @IBAction func loginWithRobinhoodBtnTrigger(_ sender: UIButton) {
        loginStatusTextView.text = "Login btn clicked"
        //http call to login
        let json: [String: Any] = ["username": usernameTextField.text,
                                   "password": passwordTextField.text]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://api.robinhood.com/api-token-auth/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                guard let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                    return
                }
                
                print("responseData: \(responseData)")

                if let token = responseData["token"] {
                    print("Token for Robinhood login: \(token).")
                    self.defaults.set(token, forKey: self.TOKEN_KEY)
                    self.login()
                } else {
                    print("Error getting token for Robinhood login.")
                    if let responseDetails = responseData["non_field_errors"] {
                        print("Error with Robinhood login: \(responseDetails).")
                    } else {
                        print("Unable to get error description for login error.")
                    }
                }
                
            } catch let error as Error {
                print(error.localizedDescription)
            }

            

        }
        task.resume()
    }

}

