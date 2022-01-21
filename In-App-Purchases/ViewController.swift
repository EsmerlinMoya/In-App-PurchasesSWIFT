//
//  ViewController.swift
//  In-App-Purchases
//
//  Created by merlin Moya on 1/20/22.
//
import StoreKit
import UIKit


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,
                      SKProductsRequestDelegate,SKRequestDelegate,SKPaymentTransactionObserver {
 
    
    private var models = [SKProduct]()
    private let tableview: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.frame = view.bounds
        fetchProducts()
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = models[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(product.localizedTitle): \(product.localizedDescription) - \(product.priceLocale.currencySymbol ?? "$")\((product.price))"
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        //Show Purchases
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
    
    //Products
    

    private let allTicketIdentifiers: Set<String> = [
    "com.test.merlin",
    "com.appcoda.storekitlocaldemo.spaghetti",
    "com.appcoda.storekitlocaldemo.cake"]
    
    private func fetchProducts(){
        let request = SKProductsRequest(productIdentifiers: allTicketIdentifiers)
        request.delegate = self
        request.start()
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count: \(response.products)")
            self.models = response.products
            self.tableview.reloadData()
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
       
        transactions.forEach({
            switch $0.transactionState{
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("did not purchase")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
    
}

