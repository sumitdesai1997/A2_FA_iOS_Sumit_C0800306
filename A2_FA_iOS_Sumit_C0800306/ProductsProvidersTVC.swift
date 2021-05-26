//
//  ProductsProvidersTVC.swift
//  A2_FA_iOS_Sumit_C0800306
//
//  Created by Sumit Desai on 21/05/21.
//  Lab Assignment 2 Completed

import UIKit
import CoreData

class ProductsProvidersTVC: UITableViewController {

    // creating product list array from the Product entity, and providerlist from the Provider entity
    var productList = [Product]()
    var providerList = [Provider]()
    var isProduct = true
    var isRedirected = false
    var selectedProduct: Product?
    var productIndex = 0
    var providerIndex = 0
    var isSave = false
    @IBOutlet weak var addProduct: UIBarButtonItem!
    
    // creating context object to work with the core data
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // search bar object
    let searchBar = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Products"
        
        showSearchBar()
        
        loadProducts()
        loadProviders()
        
        if(productList.count == 0){
            fillData()
        }
        
        tableView.reloadData()

    }
    
    // part 1: on view did appear redirect to the product details of the first row
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!isRedirected){
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            tableView.delegate?.tableView?(tableView!, didSelectRowAt: indexPath)
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // part 2: as we need to select the cell, we need to provide what we need once the cell is selected
    // if we're doing selection of row programatically then segue is not happening which we had provided from the table cell to the required screen into mainstoryboard. so we have to manually perform the seuge here
    // now we only want to perform this manual seuge once only (and that too for our provided indexpath at the time of view dead appear). so we need to provide the restriction using the flag
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isProduct){
            productIndex = indexPath.row
            performSegue(withIdentifier: "cellToProduct", sender: self)
        } else {
            providerIndex = indexPath.row
            performSegue(withIdentifier: "toProductTVC", sender: self)
        }
    }
    
    func fillData(){
        let product1 = Product(context: context)
        product1.id = 1
        product1.name = "Nightstand"
        product1.price = 20
        product1.provider = "Amazon"
        product1.stock = 100
        product1.details = "A nightstand, alternatively night table, bedside table, daystand or bedside cabinet, is a small table or cabinet designed to stand beside a bed or elsewhere in a bedroom."
        
        let product2 = Product(context: context)
        product2.id = 2
        product2.name = "Swivel Chair"
        product2.price = 25
        product2.provider = "Amazon"
        product2.stock = 200
        product2.details = "A swivel, spinny, or revolving chair is a chair with a single central leg that allows the seat to rotate 360 degrees to the left or right."
        
        let product3 = Product(context: context)
        product3.id = 3
        product3.name = "Chair"
        product3.price = 15
        product3.provider = "Snapdeal"
        product3.stock = 500
        product3.details = "One of the basic pieces of furniture, a chair is a type of seat."
        
        let product4 = Product(context: context)
        product4.id = 4
        product4.name = "Wardrobe"
        product4.price = 50
        product4.provider = "Alibaba"
        product4.stock = 500
        product4.details = "a large, tall cupboard or recess in which clothes may be hung or stored."
        
        let product5 = Product(context: context)
        product5.id = 5
        product5.name = "Pier-glass"
        product5.price = 25
        product5.provider = "Flipkart"
        product5.stock = 200
        product5.details = "a large mirror, used originally to fill wall space between windows."
        
        let product6 = Product(context: context)
        product6.id = 6
        product6.name = "Sofa"
        product6.price = 30
        product6.provider = "IKEA"
        product6.stock = 200
        product6.details = "a long upholstered seat with a back and arms, for two or more people."
        
        let product7 = Product(context: context)
        product7.id = 7
        product7.name = "Desk"
        product7.price = 20
        product7.provider = "Flipkart"
        product7.stock = 100
        product7.details = "a piece of furniture with a flat or sloping surface and typically with drawers, at which one can read, write, or do other work."
        
        let product8 = Product(context: context)
        product8.id = 8
        product8.name = "Armchair"
        product8.price = 25
        product8.provider = "IKEA"
        product8.stock = 250
        product8.details = "a large, comfortable chair with side supports for a person's arms."
        
        
        let product9 = Product(context: context)
        product9.id = 9
        product9.name = "Bed"
        product9.price = 50
        product9.provider = "IKEA"
        product9.stock = 200
        product9.details = "a piece of furniture for sleep or rest, typically a framework with a mattress."
        
        let product10 = Product(context: context)
        product10.id = 10
        product10.name = "Coffe table"
        product10.price = 20
        product10.provider = "Amazon"
        product10.stock = 500
        product10.details = "A coffee table is a low table designed to be placed in a sitting area for convenient support of beverages, remote controls, magazines, books, decorative objects, and other small items."
        
        let product11 = Product(context: context)
        product11.id = 11
        product11.name = "Stool"
        product11.price = 10
        product11.provider = "Amazon"
        product11.stock = 200
        product11.details = "a seat without a back or arms, typically resting on three or four legs or on a single pedestal."
        
        productList.append(product1)
        productList.append(product2)
        productList.append(product3)
        productList.append(product4)
        productList.append(product5)
        productList.append(product6)
        productList.append(product7)
        productList.append(product8)
        productList.append(product9)
        productList.append(product10)
        productList.append(product11)

        // adding providers programattically
        var isProviderExist = false
        for product in productList{

            for provider in providerList{
                if(product.provider == provider.name){
                    isProviderExist = true
                    // to add the relationship between the product and provider
                    product.providers = provider
                    break
                } else{
                    isProviderExist = false
                }
            }
            
            if(!isProviderExist){
                let newProvider = Provider(context: context)
                newProvider.name = product.provider
                providerList.append(newProvider)
                // to add the relationship between the product and provider
                product.providers = newProvider
            }
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return isProduct ? productList.count : providerList.count
    }
    
    // method to display the value inside the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath)
        
        if(isProduct){
            cell.textLabel?.text = productList[indexPath.row].name
            cell.detailTextLabel?.text = productList[indexPath.row].provider
            cell.imageView?.image = nil
        } else {
            cell.textLabel?.text = providerList[indexPath.row].name
            cell.detailTextLabel?.text = String(providerList[indexPath.row].products?.count ?? 0)
            cell.imageView?.image = UIImage(systemName: "folder")
        }
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(isProduct){
                
                // deleting the provider if after deleting this product there will be no more products from this product's provider
                let delProduct = productList[indexPath.row]
                var count = 0
                
                for product in productList{
                    if(product.provider == delProduct.provider){
                        count += 1
                    }
                }
                
                if(count == 1){
                    for provider in providerList{
                        if(provider.name == delProduct.provider){
                            deleteProvider(provider: provider)
                            // after deleting the data from the core data it is mandatory to save the core data
                            saveProducts()
                            loadProviders()
                        }
                    }
                }
                
                // deleting the selected product
                deleteProduct(product: productList[indexPath.row])
                // after deleting the data from the core data it is mandatory to save the core data
                saveProducts()
                productList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let delProvider = providerList[indexPath.row]
                
                // deleting all the products that are related to the provider being deleted
                for product in productList{
                    if(product.provider == delProvider.name){
                        deleteProduct(product: product)
                        // after deleting the data from the core data it is mandatory to save the core data
                        saveProducts()
                        loadProducts()
                    }
                }
                
                // deleting the selected provider
                deleteProvider(provider: providerList[indexPath.row])
                // after deleting the data from the core data it is mandatory to save the core data
                saveProducts()
                providerList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isProduct){
            let pvc = segue.destination as! ProductVC
            pvc.productList = self.productList
            pvc.providerList = self.providerList
            pvc.delegate = self
            // part 3: when we programatically selecting the row then it is not counting that sender is cell. so it will be not able to recognize the selected product. so we need to provide the default value for the selected product.
            if let _ = sender as? UIBarButtonItem {
                pvc.selectedProduct = Product(context: context)
            }
            else {
                // else will execute at the time of when the seuge is going to perform and the sender is not bar button item.
                pvc.productIndex = productIndex
                //pvc.tableView = tableView
                if(!isRedirected){
                    pvc.selectedProduct = productList[0]
                    isRedirected = true
                } else {
                    pvc.selectedProduct = productList[productIndex]
                }
                 
            }
        } else {
            let ptvc = segue.destination as? ProductTVC

            let selectedProvider = providerList[providerIndex]

            for product in productList{
                if(product.provider == selectedProvider.name){
                    ptvc?.providerProductsList.append(product.name!)
                }
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
        tableView.reloadData()
    }
    
    // method to load the products
    func loadProducts(predicate: NSPredicate? = nil){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        if let requestedPredicate = predicate{
            request.predicate = requestedPredicate
        }
    
        do{
            let tempList = try context.fetch(request)
            // as the context will fetch all objectes created for products, it will also fetch the blank object created at the time of click of plus button. so we will have to filter the object which is required only.
            productList = [Product]()
            for temp in tempList{
                if(temp.id != 0){
                    productList.append(temp)
                }
            }
        } catch{
            print("erro while loading products: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    // method to load the products
    func loadProviders(predicate: NSPredicate? = nil){
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        
        if let requestedPredicate = predicate{
            request.predicate = requestedPredicate
        }
    
        do{
            let tempList = try context.fetch(request)
            // as the context will fetch all objectes created for products, it will also fetch the blank object created at the time of click of plus button. so we will have to filter the object which is required only.
            providerList = [Provider]()
            for temp in tempList{
                if(temp.products?.count != 0){
                    providerList.append(temp)
                }
            }
        } catch{
            print("error while loading providers: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    // method to save data into context (as every time we run the simulator it will fetch the data from core data. so saving updated data into core data is mandatory)
    func saveProducts(){
        do{
            try context.save()
        } catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    // deleting data from the context for the product
    func deleteProduct(product: Product){
        context.delete(product)
    }
    
    // deleting data from the context for the provider
    func deleteProvider(provider: Provider){
        context.delete(provider)
    }
    
    // method to upload the core data
    func updateProduct(name: String, id: Int16, provider: String, price: Double, stock: Int16, details: String, providers: Provider) {
        let newProduct = Product(context: context)
        newProduct.name = name
        newProduct.id = id
        newProduct.provider = provider
        newProduct.price = price
        newProduct.stock = stock
        newProduct.details = details
        newProduct.providers = providers
        
        saveProducts()
        productList.append(newProduct)
        
        var tempProdList: [Product] = []
        for product in productList{
            if(product.id != 0){
                tempProdList.append(product)
            }
        }
        productList = tempProdList
        loadProviders()
        tableView.reloadData()
    }
    
    func showSearchBar() {
        searchBar.searchBar.delegate = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search"
        navigationItem.searchController = searchBar
        definesPresentationContext = true
        searchBar.searchBar.searchTextField.textColor = .black
    }
    
    @IBAction func showClick(_ sender: UIBarButtonItem) {
        if(isProduct){
            isProduct = false
            title = "Providers"
            sender.title = "Show Products"
            addProduct.isEnabled = false
            tableView.reloadData()
        } else {
            isProduct = true
            title = "Products"
            sender.title = "Show Providers"
            addProduct.isEnabled = true
            tableView.reloadData()
        }
    }
    
    
}

extension ProductsProvidersTVC: UISearchBarDelegate{
        
    // method to search the products as per the user input after click on search button on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // add predicate
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        if(isProduct){
            loadProducts(predicate: predicate)
        } else {
            loadProviders(predicate: predicate)
        }
    }
    
    // method for cancle button click near search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if(isProduct){
            loadProducts()
        } else {
            loadProviders()
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    // textDidChange method for search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            if(isProduct){
                loadProducts()
            } else {
                loadProviders()
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
