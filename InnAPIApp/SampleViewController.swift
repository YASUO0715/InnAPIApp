//
//  SampleViewController.swift
//  InnAPIApp
//
//  Created by Yasuo Niihori on 2021/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess
import Kingfisher

class SampleViewController: UIViewController {


    var articles:[Article] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        getArticlesInfo()
        
    }
    
    func getArticlesInfo() {
        let url = "http://localhost/api/articles"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "ACCEPT": "application/json"
        ]
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // success request
                let json = JSON(value).arrayValue
                print(json)
                for articles in json {
                    let article = Article(
                        address: articles["address"].string!,
                        phone_number: articles["phone_number"].string!,
                        caption: articles["caption"].string!
                    )
                    self.articles.append(article)
                }
                self.tableView.reloadData()
            case .failure(let err):
                // failed request
                print(err.localizedDescription)
            }
        }
    }

}

extension SampleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "niihori", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row].caption
        + " : " + articles[indexPath.row].phone_number
        return cell
    }
    
}
