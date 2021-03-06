//
//  PortofolioViewController.swift
//  MC2
//
//  Created by Linando Saputra on 17/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit

var dateCounter = 94

class PortofolioViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalBuyValLabel: UILabel!
    @IBOutlet weak var totalMarketValLabel: UILabel!
    @IBOutlet weak var unrealizedGainLossLabel: UILabel!
    @IBOutlet weak var netAssetLabel: UILabel!
    @IBOutlet weak var portofolioTableView: UITableView!
    
    
    var sortedTodayStock: [TimeSeries.StockDate] = []
    var todayBlueChipPrice: [Float] = []
    var todayMidCapPrice: [Float] = []
    var todayPennyStockPrice: [Float] = []
    
    var stockTransaction = [Transaction]()
    
    
    var jumlahArray = 1
    var tempNamaArray:[String] = []
    var tempJumlahStockArray:[Int] = []
    var temp = 0
    
    var portofolioStockName: [String] = []
    var portofolioStockAmount: [Int] = []
    
    @IBAction func InfoButton(_ sender: AnyObject) {
        
        let popInfo = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpInfo") as! InfoViewController
        self.addChild(popInfo)
        popInfo.view.frame = self.view.frame
        self.view.addSubview(popInfo.view)
        popInfo.didMove(toParent: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        portofolioTableView.tableFooterView = UIView()
        if(portofolioStockAmount.count != 0)
        {
            for i in 0...portofolioStockAmount.count-1
            {
                portofolioStockAmount[i] = 0
            }
        }
        
        todayBlueChipPrice.removeAll()
        todayMidCapPrice.removeAll()
        todayPennyStockPrice.removeAll()
        
        tempNamaArray = []
        tempJumlahStockArray = []
        jumlahArray = 0
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        do{
            stockTransaction = try managedContext!.fetch(Transaction.fetchRequest())
            
            for transaction in stockTransaction
            {
                if(transaction.type == "Buy")
                {
                    if(portofolioStockName.firstIndex(of: transaction.name!) == nil)
                    {
                        portofolioStockName.append(transaction.name!)
                        portofolioStockAmount.append(Int(transaction.amount))
                    }
                    else
                    {
                        portofolioStockAmount[portofolioStockName.firstIndex(of: transaction.name!)!] += Int(transaction.amount)
                    }
                }
                else
                {
                    portofolioStockAmount[portofolioStockName.firstIndex(of: transaction.name!)!] -= Int(transaction.amount)
                    if(portofolioStockAmount[portofolioStockName.firstIndex(of: transaction.name!)!] == 0)
                    {
                        portofolioStockAmount.remove(at: portofolioStockName.firstIndex(of: transaction.name!)!)
                        portofolioStockName.remove(at: portofolioStockName.firstIndex(of: transaction.name!)!)
                    }
                }
            }
//            if jumlahArray < 1{
//                print("ga ada isi")
//            }
//            else{
//                if jumlahArray == 1{
//                    tempNamaArray.append(stockTransaction[0].name ?? "")
//                    if stockTransaction[0].type == "Buy"{
//                        tempJumlahStockArray.append(Int(stockTransaction[0].amount))
//                    }else if stockTransaction[0].type == "Sell"{
//                        tempJumlahStockArray.append(Int(stockTransaction[0].amount - (stockTransaction[0].amount * 2)))
//                    }
//                    jumlahArray += 1
//                }
//                for j in 1...stockTransaction.count-1 {
//                    for k in 0...jumlahArray-2{
//                        //                        print(j)
//                        //                        print(stockTransaction[j].name)
//                        //                        print("pemisah")
//                        //                        print(k)
//                        //                        print(tempNamaArray[k])
//                        //                        print("selesai")
//                        if temp == 0{
//                            if stockTransaction[j].name == tempNamaArray[k]{
//                                if stockTransaction[j].type == "Buy"{
//                                    tempJumlahStockArray[k] += Int(stockTransaction[j].amount)
//                                }else if stockTransaction[j].type == "Sell"{
//                                    tempJumlahStockArray[k] -= Int(stockTransaction[j].amount)
//                                }
//                                temp+=1
//                            }
//                        }
//                        print(temp)
//
//                    }
//                    if temp == 0{
//                        tempNamaArray.append(stockTransaction[j].name ?? "")
//                        if stockTransaction[j].type == "Buy"{
//                            tempJumlahStockArray.append(Int(stockTransaction[j].amount))
//                        }else if stockTransaction[j].type == "Sell"{
//                            tempJumlahStockArray.append(Int(stockTransaction[j].amount - stockTransaction[j].amount * 2))
//                        }
//                        jumlahArray+=1
//                    }
//                    temp = 0
//                }
//            }
            
        } catch  {
            print("Gagal Memanggil")
        }
//        for i in 0...stockTransaction.count-1{
//            print(stockTransaction[i].name)
//            print(stockTransaction[i].amount)
//        }
        
        print(jumlahArray)
        print(tempNamaArray)
        print(tempJumlahStockArray)
        
        let date = Date()
        let calendar = Calendar.current
        let dateStart = calendar.startOfDay(for: UserDefaults.standard.object(forKey: "lastLoginDate") as! Date)
        let dateEnd = calendar.startOfDay(for: date)
        
        let differenceInDay = calendar.dateComponents([.day], from: dateStart, to: dateEnd).day
        let balance = UserDefaults.standard.float(forKey: "balance")
        if balance > 0{
            balanceLabel.text = "\(balance)"
        }else{
            balanceLabel.text = "0"
        }
        if(UserDefaults.standard.integer(forKey: "dateCountDown") == 0)
        {
            dateCounter = 94
        }
        else{
            dateCounter = UserDefaults.standard.integer(forKey: "dateCountDown")
        }
        DispatchQueue.main.async {
            UserDefaults.standard.set(date, forKey: "lastLoginDate")
        }
        if(UserDefaults.standard.object(forKey: "lastLoginDate") != nil)
        {
            let dateStart = calendar.startOfDay(for: UserDefaults.standard.object(forKey: "lastLoginDate") as! Date)
            let dateEnd = calendar.startOfDay(for: date)
            
            let differenceInDay = calendar.dateComponents([.day], from: dateStart, to: dateEnd).day
            if(date != (UserDefaults.standard.object(forKey: "lastLoginDate") as! Date))
            {
                dateCounter -= differenceInDay!
                UserDefaults.standard.set(dateCounter, forKey: "dateCountDown")
                UserDefaults.standard.set(date, forKey: "lastLoginDate")
            }
            print("Difference in Day: ", dateCounter)
        }
        for i in 0...9
        {
            
            do {
                let decodedBlueChip = try JSONDecoder().decode(Stock.self, from: blueChipJSON[i])
                sortedTodayStock = decodedBlueChip.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                todayBlueChipPrice.append(Float(sortedTodayStock[dateCounter].open)!)
                //print("Hari ini: ", dateCounter)
                //print("sortedtodaystock: ", sortedTodayStock[dateCounter].open)
                //print("Harga bbca: ", todayBlueChipPrice[0])
                
                let decodedMidCap = try JSONDecoder().decode(Stock.self, from: midCapJSON[i])
                sortedTodayStock = decodedMidCap.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                todayMidCapPrice.append(Float(sortedTodayStock[dateCounter].open)!)
                let decodedPennyStock = try JSONDecoder().decode(Stock.self, from: pennyStockJSON[i])
                sortedTodayStock = decodedPennyStock.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                todayPennyStockPrice.append(Float(sortedTodayStock[dateCounter].open)!)
            } catch let err{
                print("Gagal decode harga hari ini", err)
            }
        }
        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//
//        let managedContext = appDelegate?.persistentContainer.viewContext
        
        //2
        var transactions = [Transaction]()
        
        
        do {
            transactions = try managedContext!.fetch(Transaction.fetchRequest())
            var totalBuyValue: Float = 0
            var totalMarketValue: Float = 0
            for transaction in transactions{
                if(transaction.type == "Buy")
                {
                    totalBuyValue += Float(transaction.amount) * transaction.price
                    print("transaction amout: ", transaction.amount)
                    print("transaction price: ", transaction.price)
                    print("totalbuyvalue: ", totalBuyValue)
                    
                    if((blueChipSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue += Float(transaction.amount) * todayBlueChipPrice[blueChipSymbol.firstIndex(of: transaction.name!)!]
                        //print("Harga BBCA: ", todayBlueChipPrice[blueChipSymbol.firstIndex(of: transaction.name!)!])
                    }
                    if((midCapSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue += Float(transaction.amount) * todayMidCapPrice[midCapSymbol.firstIndex(of: transaction.name!)!]
                    }
                    if((pennyStockSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue += Float(transaction.amount) * todayPennyStockPrice[pennyStockSymbol.firstIndex(of: transaction.name!)!]
                    }
                }
                else
                {
                    totalBuyValue -= Float(transaction.amount) * transaction.price
                    print("transaction amout: ", transaction.amount)
                    print("transaction price: ", transaction.price)
                    print("totalbuyvalue: ", totalBuyValue)
                    if((blueChipSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue -= Float(transaction.amount) * todayBlueChipPrice[blueChipSymbol.firstIndex(of: transaction.name!)!]
                    }
                    if((midCapSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue -= Float(transaction.amount) * todayMidCapPrice[midCapSymbol.firstIndex(of: transaction.name!)!]
                    }
                    if((pennyStockSymbol.firstIndex(of: transaction.name!)) != nil)
                    {
                        totalMarketValue -= Float(transaction.amount) * todayPennyStockPrice[pennyStockSymbol.firstIndex(of: transaction.name!)!]
                    }
                }
                
            }
            if(balance > UserDefaults.standard.float(forKey: "originalBalance"))
            {
                print("totalbuyvalue sebelum ditambah if: ", totalBuyValue)
                print("original user default: ", UserDefaults.standard.float(forKey: "originalBalance"))
                print("balance: ", balance)
                print("balance - original: ", (balance - UserDefaults.standard.float(forKey: "originalBalance")))
                UserDefaults.standard.set(Float(String(format: "%.2f", (balance - UserDefaults.standard.float(forKey: "originalBalance"))))!, forKey: "totalBuyValueNeutralizer")
                //totalBuyValue = Float(String(format: "%.2f", totalBuyValue))! + Float(String(format: "%.2f", (balance - UserDefaults.standard.float(forKey: "originalBalance"))))!
                UserDefaults.standard.set(balance, forKey: "originalBalance")
                print("totalbuyvalue didalam if: ", totalBuyValue)
            }
            totalBuyValue = totalBuyValue + UserDefaults.standard.float(forKey: "totalBuyValueNeutralizer")
            totalBuyValLabel.text = "\(totalBuyValue)"
            totalMarketValLabel.text = "\(totalMarketValue)"
            //print(totalBuyValue)
            //print(totalMarketValue)
            if totalMarketValue-totalBuyValue > 0 {
                unrealizedGainLossLabel.text = "\(totalMarketValue-totalBuyValue)"
                unrealizedGainLossLabel.textColor = UIColor(displayP3Red: 0, green: 0.9, blue: 0, alpha: 1)
            }else if totalMarketValue-totalBuyValue < 0{
                unrealizedGainLossLabel.text = "\(totalMarketValue-totalBuyValue)"
                unrealizedGainLossLabel.textColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 1)
            }else{
                unrealizedGainLossLabel.text = "\(totalMarketValue-totalBuyValue)"
            }
            netAssetLabel.text = "\(Float(balance) + totalMarketValue)"
//            if(totalMarketValue == 0 && totalBuyValue != 0)
//            {
//                totalBuyValue += Float(String(unrealizedGainLossLabel
//                    .text!))!
//                totalBuyValLabel.text = "\(totalBuyValue)"
//                unrealizedGainLossLabel.text = "\(totalMarketValue-totalBuyValue)"
//                unrealizedGainLossLabel.textColor = .white
//            }
            print("totalbuyvalue: ", totalBuyValue)
        } catch  {
            print("Gagal Memanggil")
        }
        
        // Do any additional setup after loading the view.
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//
//        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
//
//        //2
//        var users = [User]()
//
//        do {
//            users = try managedContext.fetch(User.fetchRequest())
//            balanceLabel.text = "\(users[users.count-1].balance)"
//        } catch  {
//            print("Gagal Memanggil")
//        }
        if(Float(String(unrealizedGainLossLabel.text!)) == 0)
        {
            unrealizedGainLossLabel.textColor = .white
        }
        portofolioTableView.reloadData()
        
    }
    

}
extension PortofolioViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var tableSize:Int = 0
//        //salah
//        for transaction in 0...stockTransaction.count {
//            if stockTransaction[transaction].amount > 0{
//                tableSize+=1
//            }
//        }
//        return tableSize
        //return jumlahArray-1
        return portofolioStockName.count
        //            return stockTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortofolioTableViewCell") as! PortofolioTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.stockNameLabel.text = portofolioStockName[indexPath.row]
        cell.stockAmountLabel.text = "\(portofolioStockAmount[indexPath.row])"
        
        return cell
    }
    
    
}
