//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import UIKit

class RecentsTVC: UITableViewController {

    private let store = StoreModel() // Access user defaults

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return store.recentLog.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showHistory", for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = store.recentLog[indexPath.row].description
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let destinationVC = self.tabBarController?.viewControllers?[0] as? UINavigationController {
            if let view = destinationVC.viewControllers[0] as? TweetsTVC {
                view.twitterQueryText = store.recentLog[indexPath.row].description
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
}
