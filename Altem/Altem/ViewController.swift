//
//  ViewController.swift
//  Altem
//
//  Created by Danilo enrique  Diaz rios on 20/11/17.
//  Copyright © 2017 Danilo enrique  Diaz rios. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    var flag = String()
    var token:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginBtn(_ sender: UIButton) {
        if usernameTextField.text!.isEmpty {
            print("nombre vacio")
        } else if passwordTextField.text!.isEmpty {
            print("contraseña vacia")
        } else {
            let username = usernameTextField.text
            let password = passwordTextField.text
            Dologin(String(describing: username!), String(describing: password!))
            if token != nil{
                if String(describing: token!) != "" {
                    performSegue(withIdentifier: "segue", sender: self)
                }
            }
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if token != nil{
        let navc = segue.destination as! UINavigationController
            let listController = navc.viewControllers.first as! studentsController
            listController.myToken = String(describing: token!)
            }
    }
    
    func Dologin(_ user:String, _ psw:String){
        let url = URL(string: "http://192.34.79.113/api/login/")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "code=" + user + "&password=" + psw
        
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) in
            
            guard let _:Data = data else{
                return
            }
            let json:Any?
            
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = json as? [String: Any]{
                    if let result = dictionary["result"] as? [String: Any]{
                        self.token = result["token"]
                        
                    }
                }
                
                
            } catch {
                return
            }
            
        
        })
        task.resume()
        
    }
    
    
}


