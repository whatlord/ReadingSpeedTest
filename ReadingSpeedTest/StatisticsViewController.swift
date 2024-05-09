//
//  StatisticsViewController.swift
//  ReadingSpeedTest
//
//  Created by Andrew Jenkins on 11/22/22.
//

import UIKit

class StatisticsViewController: UITableViewController {
    
    var user = (UIApplication.shared.delegate as! AppDelegate).user
    var users = (UIApplication.shared.delegate as! AppDelegate).users

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        users = (UIApplication.shared.delegate as! AppDelegate).users
        user = (UIApplication.shared.delegate as! AppDelegate).user
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        return users.count()
        
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User Stats"
        }
        return "Other Users"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statIdentifier = "StatCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: statIdentifier, for: indexPath)
        if indexPath.section == 0 {
            if(indexPath.row > 2){
                cell.textLabel!.text = "Total"
                cell.detailTextLabel?.text = "\(user.history.count) times"
            }else{
                let speedStat = user.lastThree()[indexPath.row]!
                if speedStat == 0 {
                    cell.textLabel!.text = "No data"
                    cell.detailTextLabel?.text = ""
                }else{
                    cell.textLabel!.text = "\(user.lastThree()[indexPath.row]!) WPM"
                    cell.detailTextLabel?.text = "\(user.speedCount(user.lastThree()[indexPath.row]!)) times"
                }
            }
            
            
        }else{
            let user = users.users.sorted(by: {$0.topSpeed() ?? 0 > $1.topSpeed() ?? 0})[indexPath.row]
            cell.textLabel!.text = user.username
            if let speed = user.topSpeed() {
                cell.detailTextLabel?.text = "\(speed) WPM"
            }else{
                cell.detailTextLabel?.text = "No data available"
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
           headerView.textLabel?.textColor = UIColor.red
        }
    }

}
