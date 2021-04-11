//  TweetTVCell.swift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/16.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetTVCell: UITableViewCell {

    var tweet: TwitterTweet? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var tweetScreenName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    
    private func updateCell() {
        guard tweet != nil else {
            // set everything to nil because nothing was retrieved
            tweetScreenName.text = nil
            tweetText.attributedText = nil
            tweetDate.text = nil
            tweetImage = nil
            return
        }
        
        // MARK: - tweetScreenName
        tweetScreenName.text = "\(tweet!.user)"
        
        // MARK: - tweetDate
        tweetDate.text = tweetDateFormatter(tweet!.created)
        
        // MARK: - tweetText
        colorCodeText()
        
        // MARK: - tweetImage
        fetchTweeterProfileImage()

    }
    
    private func colorCodeText() {
        // Twitter Mentions to be color coded
        let hashtags = tweet?.hashtags
        let urls = tweet?.urls
        let mentions = tweet?.userMentions
        
        let attributedString = NSMutableAttributedString(string: tweet!.text)
        
        for hashtag in hashtags! {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: hashtag.nsrange)
        }
        
        for url in urls! {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: url.nsrange)
        }
        
        for mention in mentions! {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: mention.nsrange)
        }
        
        tweetText.attributedText = attributedString
    }
    
    // Format "EEE MMM dd HH:mm:ss Z yyyy" to "h:mm a"
    private func tweetDateFormatter(_ date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: date)
    }
    
    // Update cell profile image
    private func fetchTweeterProfileImage() {
        if let url = tweet!.user.profileImageURL {
            DispatchQueue.global(qos: .background).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.tweetImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    
}
