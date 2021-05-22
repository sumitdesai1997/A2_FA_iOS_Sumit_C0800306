//
//  DetailsTVC.swift
//  A2_FA_iOS_Sumit_C0800306
//
//  Created by Sumit Desai on 21/05/21.
//

import UIKit
import CoreData

class ProductsProvidersTVC: UITableViewController {

    // creating product list array from the Product entity
    var productList = [Product]()
    
    // creating context object to work with the core data
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Products"
        
        loadProducts()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productList.count
    }
    
    // method to display the value inside the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath)
        cell.textLabel?.text = productList[indexPath.row].name
        cell.detailTextLabel?.text = productList[indexPath.row].provider
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProduct(product: productList[indexPath.row])
            // after deleting the data from the core data it is mandatory to save the core data
            saveProducts()
            productList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pvc = segue.destination as! ProductVC
        pvc.productList = self.productList
        
        // if the navigation is happening on the click of the cell from tableview
        if let cell = sender as? UITableViewCell {
            if let index = tableView.indexPath(for: cell)?.row {
                pvc.selectedProduct = productList[index]
            }
        }
    }
    
    // on the click of plus button at the bottom toolbar we're navigating to the ProductVC using Present Modaly segue and not using the show segue
    // so at the time of getting back from productVC to PPTVC, we need to use this unwind segue, which is an IBAction
    // to perform this, we need to create this IBAction segue in the depart screen and in the mainstoryboard we have to connect ProductVC to Exit (both options are available just above to the ProductVC screen and select the name of this IBAction segue, give the name to this segue. That's it, now we can perform this segue whenever required in the ProductVC)
    @IBAction func unwindToPPTVC(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        saveProducts()
        loadProducts()
        tableView.reloadData()
        print("Product list:\(productList)")
    }
    
    // method to load the products
    func loadProducts(){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        do{
            productList = try context.fetch(request)
        } catch{
            print("erro while loading products: \(error.localizedDescription)")
        }
    }
    
    // method to save data into context (as every time we run the simulator it will fetch the data from core data. so saving updated data into core data is mandatory)
    func saveProducts(){
        do{
            try context.save()
        } catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    // deleting data from the context
    func deleteProduct(product: Product){
        context.delete(product)
    }
    
}
