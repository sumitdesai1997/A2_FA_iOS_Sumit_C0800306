//
//  ProductVC.swift
//  A2_FA_iOS_Sumit_C0800306
//
//  Created by Sumit Desai on 22/05/21.
//

import UIKit
import CoreData

class ProductVC: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var providerTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    
    // creating the product list here that will have the value from the ProductsProvidersTVC
    var productList = [Product]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        if shouldPerformSegue(withIdentifier: "toThePPTVC", sender: self){
            // do your work before you want to perform segue below then call perform segue
            
            performSegue(withIdentifier: "toThePPTVC", sender: self)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pptvc = segue.destination as! ProductsProvidersTVC
        pptvc.productList = self.productList
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return validateData()
    }
    
    // validating the data entered by user
    func validateData() -> Bool{
        if(nameTF.text == "" || idTF.text == "" || providerTF.text == "" || priceTF.text == "" || stockTF.text == ""){
            return false
        } else {
            // if value entered by user then create Object of Product and add that object to productList
            let newProduct = Product(context: self.context)
            newProduct.name = nameTF.text
            if let id = idTF.text{
                newProduct.id = Int16(id)!
            }
            newProduct.provider = providerTF.text
            newProduct.price = Double(priceTF.text!)!
            if let stock = stockTF.text{
                newProduct.stock = Int16(stock)!
            }
            self.productList.append(newProduct)
        }
        return true
    }
    
}

