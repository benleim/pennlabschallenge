//
//  ViewController.swift
//  PennLabsDining
//
//  Created by William Leimberger on 9/22/18.
//  Copyright © 2018 William Leimberger. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gymnasiums = [Any]()
    @IBOutlet weak var hallTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymnasiums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "hall_cell", for: indexPath) as! GymTableViewCell
        let gyms = self.gymnasiums[indexPath.row] as! NSDictionary
        let all_day = gyms["all_day"] as! Bool
        var name = gyms["name"] as! String
        
        if (all_day) {
            // Check if open/closed from the name
            if name.contains("OPEN") {
                cell.StatusLabel.text = "OPEN"
                cell.StatusLabel.textColor = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
            } else if name.contains("CLOSED") {
                cell.StatusLabel.text = "CLOSED TODAY"
            }
        } else {
            // Check if the start/end times exist
            if var start = gyms["start"] as? String {
                if var end = gyms["end"] as? String {
                    start.removeLast(6)
                    end.removeLast(6)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let startDate = formatter.date(from: start)!
                    let endDate = formatter.date(from: end)!
                    let now = Calendar.current.date(
                        byAdding: .hour,
                        value: -4,
                        to: Date())!
                    
                    let isOpenNow = startDate <= now && now <= endDate
                    if isOpenNow {
                        cell.StatusLabel.text = "OPEN"
                        cell.StatusLabel.textColor = UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0)
                        let formatter2 = DateFormatter()
                        formatter2.dateFormat = "ha"
                        var openTime = formatter2.string(from: startDate)
                        openTime.removeLast(1)
                        var closeTime = formatter2.string(from: endDate)
                        closeTime.removeLast(1)
                        cell.TimesLabel.text = openTime.lowercased() + " - " + closeTime.lowercased()
                    } else {
                        cell.StatusLabel.text = "CLOSED"
                    }
                }
            }
        }
        
        // Sanitize the name for display
        name = name.replacingOccurrences(of: "CLOSED", with: "")
        name = name.replacingOccurrences(of: "OPEN", with: "")
        name = name.replacingOccurrences(of: "-", with: "")
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.TitleLabel.text = name
        
        // Handle the image to post for each cell
        cell.HallImage.layer.masksToBounds = true
        cell.HallImage.layer.cornerRadius = 8
        if (name.contains("Pottruck") || name.contains("Climbing Wall") || name.contains("Membership Services")) {
            cell.HallImage.image = UIImage(named: "climbing.jpg")
        } else if (name.contains("Ringe")) {
            cell.HallImage.image = UIImage(named: "ringe.jpg")
        } else if (name.contains("Fox")) {
            cell.HallImage.image = UIImage(named: "fox.jpg")
        } else if (name.contains("Sheerr Pool")) {
            cell.HallImage.image = UIImage(named: "sheerr.jpg")
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UITableView style changes
        self.hallTableView.allowsSelection = false
        self.hallTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        Alamofire.request("https://api.pennlabs.org/fitness/schedule").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var dictonary:NSDictionary?
                
                if let data = utf8Text.data(using: String.Encoding.utf8) {
                    do {
                        dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                        
                        if let myDictionary = dictonary {
                            self.gymnasiums = (myDictionary["schedule"] as! [Any])
                            self.hallTableView.reloadData()
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

