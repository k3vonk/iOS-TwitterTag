//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/15.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var twitterQueryTextField: UITextField! {
        didSet {
            twitterQueryTextField.delegate = self
            twitterQueryTextField.text = twitterQueryText!
        }
    }
    
    private let store = StoreModel() // Store user defaults...
    
    var tweets = [[TwitterTweet]]()
    var twitterQueryText: String? = "#ucd"{
        didSet {
            twitterQueryTextField!.text = twitterQueryText!
            store.addRecentTweet(twitterQueryText!)
            refresh()  // trigger refresh method on input
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup tableView...
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        refresh()
    }
    
    // MARK: - Action Method
    @IBAction private func refresh() {
        tweets.removeAll() // clear out previous tweets
        self.tableView.reloadData()  // update data in the cells
        // Request up to 8 tweets
        let request = TwitterRequest(search: twitterQueryText!, count: 8)
        request.fetchTweets { (newTweets) -> Void in
            Thread.sleep(forTimeInterval: 0.2)
            DispatchQueue.main.async { () -> Void in
                if newTweets.count > 0 {
                    self.tweets.insert(newTweets, at: 0)
                }
                print("\(newTweets)")
                self.tableView.reloadData()  // update data in the cells

            }
            
        }
    
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTVCell", for: indexPath) as? TweetTVCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet

        return cell
    }
    
    // MARK: - UITextViewDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        twitterQueryText = textField.text!
        twitterQueryTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get the indexes for a specific tweet
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let tweet = tweets[indexPath.section][indexPath.row]
            
            if let destinationVC = segue.destination as? MentionsTVC {
                destinationVC.title = "\(tweet.user.name)"
                destinationVC.tweet = tweet
            }
        }
    }
    
    // segue back to this VC
    @IBAction func unwindToTweetTVC(segue: UIStoryboardSegue) {}
}

