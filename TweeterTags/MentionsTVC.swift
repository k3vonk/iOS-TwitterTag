//  MentionsTVCswift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/16.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import UIKit

class MentionsTVC: UITableViewController {
    var tweet: TwitterTweet?
    
    private struct Constants {
        static let sections = ["Images", "Hashtags", "Users", "URLs"]
        static let rowHeightWithImage: CGFloat = CGFloat(244)
        static let rowHeightWithoutImage: CGFloat = CGFloat(44)
    }
    
    enum StoryboardIdentifiers: String, CustomStringConvertible{
        case displayMentionImage = "showMentionImage"
        case displayTweetRequest = "showTweetsTVC"
        
        init?(_ segue: UIStoryboardSegue) {
            self.init(rawValue: segue.identifier!)
        }
        
        var description: String { get { return self.rawValue } }
    }
    
    enum SectionIdentifiers: Int {
        case images = 0
        case hashtags = 1
        case users = 2
        case urls = 3
        
        init?(_ section: Int) {
            self.init(rawValue: section)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure tableView to scale row dimensions
        tableView.estimatedRowHeight = Constants.rowHeightWithoutImage
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return Constants.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        switch SectionIdentifiers(section) {
        case .images:
            return (tweet?.media.count)!
        case .hashtags:
            return (tweet?.hashtags.count)!
        case .users:
            return (tweet?.userMentions.count)!
        case .urls:
            return (tweet?.urls.count)!
        case .none:
            return 0
        }
    }
    
    // Cell Headers
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var text: String?
        
        switch SectionIdentifiers(section) {
        case .images:
            if (tweet?.media.count)! > 0 { text = Constants.sections[section] }
        case .hashtags:
            if (tweet?.hashtags.count)! > 0 { text = Constants.sections[section] }
        case .users:
            if (tweet?.userMentions.count)! > 0 { text = Constants.sections[section] }
        case .urls:
            if (tweet?.urls.count)! > 0 { text = Constants.sections[section] }
        case .none:
           text = nil
        }
        
        return text
    }
    
    // Adjust row height if image is present
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.rowHeightWithImage
        }
        return Constants.rowHeightWithoutImage
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTVCell", for: indexPath) as? MentionTVCell else {
            return UITableViewCell()
        }

        // Configure the cell...
        switch SectionIdentifiers(indexPath.section) {
        case .images:
            cell.spinner?.startAnimating()
            // fetch image...
            if let url = tweet?.media[indexPath.row].url {
                DispatchQueue.global(qos: .background).async {
                    Thread.sleep(forTimeInterval: 1)
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            cell.mentionImage.image = UIImage(data: data)
                            cell.spinner?.stopAnimating()
                        }
                    }
                }
            }
        case .hashtags:
            cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .users:
            cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .urls:
            cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case .none:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Perform segue depending on which section the user selected
        switch SectionIdentifiers(indexPath.section) {
        case .images:
            performSegue(withIdentifier: StoryboardIdentifiers.displayMentionImage.description, sender: tweet?.media[indexPath.row].url)
        case .hashtags:
            performSegue(withIdentifier: StoryboardIdentifiers.displayTweetRequest.rawValue, sender:
                tweet?.hashtags[indexPath.row].keyword)
        case .users:
            performSegue(withIdentifier: StoryboardIdentifiers.displayTweetRequest.rawValue, sender: tweet?.userMentions[indexPath.row].keyword)
        case .urls:
            guard let url = URL(string: tweet!.urls[indexPath.row].keyword) else {
                return
            }
            
            // Open URL depending on iOS version
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case .none:
           break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch StoryboardIdentifiers(segue)! {
        case .displayMentionImage:
            if let destinationVC = segue.destination as? ImageVC {
                if let url = sender as? URL {
                    destinationVC.imageURL = url
                }
            }
        case .displayTweetRequest:
            if let destinationVC = segue.destination as? TweetsTVC {
                let text = sender as! String
                destinationVC.twitterQueryText = text
            }
        }
    }
    
    
    
}
