//
//  NotificationViewController.swift
//  MGNotificationContentExtension
//
//  Created by Marco Guerrieri on 12/09/2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func firstButtonTap(_ sender: Any) {
        firstButton.setTitle("1st Button tapped!", for: .normal)
    }
    
    @IBAction func secondButtonTap(_ sender: Any) {
        secondButton.setTitle("2nd Button tapped!", for: .normal)
    }
    
    func didReceive(_ notification: UNNotification) {
        titleLabel.text = notification.request.content.title
        subtitleLabel.text = notification.request.content.subtitle
        bodyLabel.text = notification.request.content.body
        
        guard let customFields = notification.request.content.userInfo["aps"] as? [String: Any] else { return }
        print(customFields)
        let footerText = customFields["footer"] as? String
        let firstButtonText = customFields["firstButton"] as? String
        let secondButtonText = customFields["secondButton"] as? String
        let imageUrl = customFields["imageUrl"] as? String
        
        footerLabel.text = footerText
        firstButton.setTitle(firstButtonText, for: .normal)
        secondButton.setTitle(secondButtonText, for: .normal)
        imageView.loadImage(withUrl: imageUrl ?? "")
    }

}

extension UIImageView {
    func loadImage(withUrl urlString : String) {
        image = nil
        
        guard let url = URL(string: urlString) else { return }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        addConstraints(
            [NSLayoutConstraint(item: activityIndicator,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: activityIndicator,
                                attribute: .centerY,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .centerY,
                                multiplier: 1,
                                constant: 0)])
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
                activityIndicator.removeFromSuperview()
            }

        }).resume()
    }
}

