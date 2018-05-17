//
//  DetailViewController.swift
//  垃圾車來了
//
//  Created by 林松賢 on 2018/5/17.
//  Copyright © 2018年 林松賢. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK:  IBOutlet and property
    @IBOutlet var infoTableView: UITableView!
    var car: String?
    
    //MARK: Data Struct of json
    struct DustCart: Decodable {
        var lineid: String
        var car: String
        var time: String
        var location: String
        var longitude: String
        var latitude: String
        var cityid: String
        var cityname: String
    }
    var dustcarts: [DustCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoTableView.dataSource = self
        infoTableView.delegate = self
        
        print(car!)
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dustCartDetailCell", for: indexPath) as! DetailViewTableViewCell
        
        
        for dustcart in self.dustcarts {
            if dustcart.car == self.car! {
                switch indexPath.row {
                case 0:
                    cell.informationLabel.text! = dustcart.car
                case 1:
                    cell.informationLabel.text! = dustcart.latitude + " " + dustcart.longitude
                case 2:
                    cell.informationLabel.text! = dustcart.lineid
                case 3:
                    cell.informationLabel.text! = dustcart.cityname
                case 4:
                    cell.informationLabel.text! = dustcart.time
                default:
                    cell.informationLabel.text! = "no value."
                }
            }
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Fetch data Function.
    func fetchData() {
        let url = URL(string: "http://data.ntpc.gov.tw/od/data/api/28AB4122-60E1-4065-98E5-ABCCB69AACA6?$format=json")
        
        let task = URLSession.shared.dataTask(with: url!) { (jsonData, response, error) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let data = jsonData, let carts = try? decoder.decode([DustCart].self, from: data) {
                for cart in carts {
                    self.dustcarts.append(cart)
                    DispatchQueue.main.async {
                        self.infoTableView.reloadData()
                    }
                }
            } else {
                print("error")
            }
        }
        task.resume()
    }

}
