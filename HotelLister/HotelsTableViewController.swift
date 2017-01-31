//
//  HotelsTableViewController.swift
//  HotelLister
//
//  Created by Nicholas Allio on 23/11/2016.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class HotelsTableViewController: UITableViewController {
    fileprivate let avgReview: Float = 8.0
    var tableSections = [String]()  //Array of strings containing name of cities
    var sectionRows = [[Hotel]]()   //Array of Hotels. Index of each array corresponds to same index of tableSections related city
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //indicator view to inform the user of the backgound parsing in process
        indicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y - (self.navigationController?.navigationBar.frame.height)!)
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        loadHotels()

    }
    
    func loadHotels() {
        let hotelParser = JsonHotelParser()
        hotelParser.getHotels { (hotelsMap) in
            if let hotelsMap = hotelsMap {
                for (key, value) in hotelsMap {
                    //for each pair "city" "hotel list" they are inserted at the same indexes in corresponding structures
                    self.tableSections.append(key)
                    
                    //hotels filtered by desidered reviewScore
                    var hotelsWithScore = [Hotel]()
                    for hotel in value {
                        if let score = hotel.reviewScore, !score.isLess(than: self.avgReview) {
                            hotelsWithScore.append(hotel)
                        }
                    }
                    //selected hotels sorted by reviewScore
                    hotelsWithScore.sort(by: { (a, b) -> Bool in
                        return a.reviewScore! > b.reviewScore!
                    })
                    self.sectionRows.append(hotelsWithScore)
                }
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.indicator.removeFromSuperview()
                    self.tableView.reloadData()
                }
            } else {
                //nil value returned from parsing operation -> display alert to user and retry
                let alert = UIAlertController(title: "Error", message: "An error occurred while parsing hotels.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.loadHotels()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //generic header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        headerView.backgroundColor = UIColor(red: 41/255, green: 135/255, blue: 242/255, alpha: 0.5)
        
        //label with city name
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 6, width: tableView.frame.width - 20, height: 16))
        let attributedTitle = NSAttributedString(string: tableSections[section], attributes: [NSForegroundColorAttributeName:UIColor.blue,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)])
        titleLabel.attributedText = attributedTitle
        
        headerView.addSubview(titleLabel)
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell", for: indexPath) as! HotelTableViewCell
        let currentHotel = sectionRows[indexPath.section][indexPath.row] as Hotel

        cell.nameHotelLabel.text = currentHotel.name
        cell.addressHotelLabel.text = "\(currentHotel.address!), \(currentHotel.district!) \(currentHotel.zipCode!) \(currentHotel.city!)"
        
        var stars = ""
        for _ in 0..<currentHotel.starRating! {
            stars.append("⭐️")
        }
        cell.starRatingHotelLabel.text = stars
        
        cell.ratingHotelLabel.text = "\(currentHotel.reviewScore!)"

        return cell
    }

}
