////  ImageVC.swift
//  TweeterTags
//
//  Created by Ga Jun Young on 2020/3/16.
//  Copyright © 2020 COMP47390-41550. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    // MARK: - Private properties
    private var imageView = UIImageView()
    
    private var mentionImage: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageView.frame = CGRect(origin: CGPoint.zero, size: imageView.frame.size)
            scrollView?.contentSize = imageView.frame.size
            
            // Zoom to top left whilst having full height of image
            scrollView?.maximumZoomScale = max(scrollView.bounds.size.width / scrollView.contentSize.width, scrollView.bounds.size.height / scrollView.contentSize.height)
            scrollView?.minimumZoomScale = min(scrollView.bounds.size.width / scrollView.contentSize.width, scrollView.bounds.size.height / scrollView.contentSize.height)
            scrollView?.zoomScale = max(scrollView.bounds.size.width / scrollView.contentSize.width, scrollView.bounds.size.height / scrollView.contentSize.height)
            spinner?.stopAnimating()
        
        }
    }
    
    // MARK: - Data model
    open var imageURL: URL? {
        didSet {
            mentionImage = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // MARK: - Multithreaded pattern
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .background).async {
                Thread.sleep(forTimeInterval: 2)
                let imageData = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if imageData != nil  {
                        self.mentionImage = UIImage(data: imageData!)
                    } else {
                        self.mentionImage = nil
                    }
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - VC lifecylcle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mentionImage == nil {
            fetchImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
