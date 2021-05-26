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
    @IBOutlet weak var detailsTV: UITextView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    // creating the product list, provider list here that will have the value from the ProductsProvidersTVC
    var productList = [Product]()
    var providerList = [Provider]()
    var selectedProduct : Product?
    var productIndex = 0
    weak var delegate : ProductsProvidersTVC?
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTF.text = selectedProduct?.name
        idTF.text = String(selectedProduct?.id ?? 0)
        providerTF.text = selectedProduct?.provider
        priceTF.text = String(selectedProduct?.price ?? 0.0)
        stockTF.text = String(selectedProduct?.stock ?? 0)
        detailsTV.text = selectedProduct?.details
        
        if(idTF.text == String(0)){
            idTF.text = ""
        }
        if(priceTF.text == String(0.0)){
            priceTF.text = ""
        }
        if(stockTF.text == String(0)){
            stockTF.text = ""
        }
        
        if(nameTF.text != ""){
            btnCancel.isHidden = true
            
            nameTF.isEnabled = false
            idTF.isEnabled = false
        }
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        if shouldPerformSegue(withIdentifier: "toThePPTVC", sender: self){
            // do your work before you want to perform segue below then call perform segue
           if(!nameTF.isEnabled){
                self.navigationController?.popViewController(animated: true)
            } else {
                performSegue(withIdentifier: "toThePPTVC", sender: self)
            }
        }
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        performSegue(withIdentifier: "toThePPTVC", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pptvc = segue.destination as! ProductsProvidersTVC
        pptvc.productList = self.productList
        pptvc.providerList = self.providerList
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return validateData()
    }
    
    // validating the data entered by user
    func validateData() -> Bool{
        if(nameTF.text == "" || idTF.text == "" || providerTF.text == "" || priceTF.text == "" || stockTF.text == "" || detailsTV.text == ""){
            return false
        } else {
            // if value entered by user then create Object of Product and add that object to productList
            
            // if named is not enabled it means, that user is here to update the data, so updating the product here
            if(!nameTF.isEnabled){
                for product in productList{
                    if(product.name == nameTF.text!){
                        delegate?.deleteProduct(product: product)
                        delegate?.saveProducts()
                        productList.remove(at: productIndex)
                        //delegate?.tableView.deleteRows(at: [IndexPath(row: productIndex, section: 0)], with: .fade)
                        
                        var isProviderExist = false
                        var newProvider = Provider(context: context)
                        for provider in providerList{
                            if(provider.name == providerTF.text!){
                                newProvider = provider
                                isProviderExist = true
                            }
                        }
                        
                        if(!isProviderExist){
                            newProvider.name = providerTF.text
                            self.providerList.append(newProvider)
                        }
                        
                        delegate?.updateProduct(name: nameTF.text!, id: Int16(idTF.text!)!, provider: providerTF.text!, price: Double(priceTF.text!)!, stock: Int16(stockTF.text!)!, details: detailsTV.text!, providers: newProvider)
                    }
                }
            } else {
                // user is here to add the product
                
                var isProviderExist = false
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
                newProduct.details = detailsTV.text
                self.productList.append(newProduct)
                
                // to check if the provider is already exist or not
                for provider in self.providerList{
                    if(newProduct.provider == provider.name){
                        isProviderExist = true
                        // adding relationship for newly added product
                        newProduct.providers = provider
                        break
                    }
                }
                
                if(!isProviderExist){
                    let newProvider = Provider(context: context)
                    newProvider.name = newProduct.provider
                    self.providerList.append(newProvider)
                    // adding relationship for newly added product
                    newProduct.providers = newProvider
                }
            }
        }
        return true
    }
    
}

