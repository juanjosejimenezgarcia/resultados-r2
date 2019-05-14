//
//  ViewController.swift
//  Elections
//
//  Created by LABMAC05 on 26/04/19.
//  Copyright © 2019 utng.christian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    
    
    var ref = DatabaseReference.init()
    
    @IBOutlet weak var idtext: UITextField!
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var grupo: UITextField!
    @IBOutlet weak var cal: UITextField!
    /*
    @IBOutlet weak var idtext: UITextField!
    @IBOutlet weak var txtCandText: UITextField!
    @IBOutlet weak var txtPersonText: UITextField!
    */
    @IBOutlet weak var myTabla: UITableView!
    
    var myList:[String] = []
    var handle:DatabaseHandle?
    //var ref :DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginAnony()
        self.ref = Database.database().reference()
        listar()
        
    }
    
    
    
    
    func loginAnony()
    {
        Auth.auth().signInAnonymously()
            {
                (user, error) in
                
                if let error = error
                {
                    print ("Cannot login: \(error)")
                }else
                {
                    print ("user UID \(String(describing: user?.user))")
                    
                }
        }
    }
    
    
    @IBAction func bSend(_ sender: Any) {
        let env = ["ID" : idtext.text!,"Nombre" : nombre.text!,
                   "Grupo" : grupo.text!, "Calificacion" : cal.text!,
        ]
        self.ref.child("list").child(idtext.text!).setValue(env)
        idtext.text! = ""
        grupo.text! = ""
        nombre.text = ""
        cal.text = ""
        
    }
    
    @IBAction func actualizar(_ sender: Any) {
        
        
        self.ref.child("list").child(idtext.text!).setValue(["ID" : idtext.text!,"Nombre" : nombre.text!,
                                                                     "Grupo" : grupo.text!, "Calificacion" : cal.text!,])
        idtext.text! = ""
        grupo.text! = ""
        nombre.text = ""
        cal.text = ""
        listar()
        
    }
    @IBAction func borrar(_ sender: Any) {
        
        self.ref.child("list").child(idtext.text!).removeValue()
        idtext.text! = ""
        grupo.text! = ""
        nombre.text = ""
        cal.text = ""
        listar()
    }
    
    @IBAction func mostrar(_ sender: Any) {
        handle = self.ref.child("list").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value ?? "No item")
            if let item = snapshot.value as? [String : String]{
                
                
                self.myList.append(" \(item["ID"]!) \(item["nombre"]!)")
                self.myTabla.reloadData()
                
                
            }
            
        })
        
    }
    
    func listar() {
        myList.removeAll()
        handle = self.ref.child("list").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value ?? "No item")
            if let item = snapshot.value as? [String : String]{
                
                
                self.myList.append(" \(item["Nombre"]!) \(item["Calificacion"]!)")
                self.myTabla.reloadData()
                
                
            }
            
        })
        
    }
    
}
