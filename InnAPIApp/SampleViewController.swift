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
import CoreLocation

//import SDWebImage


class SampleViewController: UIViewController{


    var articles:[Article] = []
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("latitude:", latitude)
        print("longitude:", longitude)

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
                
        
        getArticlesInfo()
//        print("経度：\(String(describing: latitude)), 緯度：\(String(describing: longitude))")
        
    }
    
    func getArticlesInfo() {
        let url = "http://localhost/api/articles"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "ACCEPT": "application/json"
        ]
        //パラメータ追加
        
        let parameters: Parameters = [
                 "latitude": latitude,
                 "longitude": longitude
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                // success request
                let json = JSON(value).arrayValue
                
                for articles in json {
                    let article = Article(
                        address: articles["address"].string!,
                        phone_number: articles["phone_number"].string!,
                        caption: articles["caption"].string!,
                        latitude: Decimal(Double(articles["latitude"].string ?? "0.0") ?? 0.0),
                        longitude: Decimal(Double(articles["longitude"].string ?? "0.0") ?? 0.0),
                        attachments: articles["attachments"].string,
                        image_url: articles["image_url"].string!,
                        distance: Float(Double(articles["distance"].string ?? "0.0") ?? 0.0)
                    )
                    self.articles.append(article)
                }
                print(self.articles)
                self.tableView.reloadData()
            case .failure(let err):
                // failed request
                print(err.localizedDescription)
            }
        }
    }

}

extension SampleViewController: UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "niihori", for: indexPath)

        
//        let profileImageView = cell.viewWithTag(1) as! UIImageView
//        profileImageView.sd_setImage(with: URL(string: articles[indexPath.row].attachments.profileImageString), completed: nil)
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        profileImageView.kf.setImage(with: URL(string: articles[indexPath.row].image_url))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        let captionLabel = cell.viewWithTag(2) as! UILabel
         captionLabel.text = articles[indexPath.row].caption
        
        let phoneNumberLabel = cell.viewWithTag(3) as! UILabel
        phoneNumberLabel.text = articles[indexPath.row].phone_number
        
        
//        cell.textLabel?.text = articles[indexPath.row].caption
//        + " : " + articles[indexPath.row].phone_number
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return self.view.frame.height * 2 / 3
        }
    
}

