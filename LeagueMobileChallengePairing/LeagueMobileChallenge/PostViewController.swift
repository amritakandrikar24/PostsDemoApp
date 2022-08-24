//
//  PostViewController.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/23/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

class PostViewController: UITableViewController {
    
    var viewModel:PostViewControllerViewModel?
    
    override func viewDidLoad() {
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        initialSetUp()
    }
    
    // Initial set up for view
    private func initialSetUp() {
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        viewModel?.reloadData = { [self] in
            if let post = self.viewModel?.posts,
               let user = self.viewModel?.users,
               post.isEmpty,
               user.isEmpty {
                   self.showAlert()
               } else {
                   self.tableView.reloadData()
               }
        }
        // Fetch user and post data
        viewModel?.fetchData()
    }
    
    // This can be configured according to project requirment
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// Table view delegates extension 
extension PostViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell

        guard let post = viewModel?.posts[indexPath.row], let users = viewModel?.users else {
            return cell
        }
        
        cell.title?.text = post.title
        cell.descriptionlbl?.text = post.body
        let temp = users.filter {
            $0.id == post.userId
        }
        cell.userName.text = temp[0].username
        ImageDownloader.shared.downloadImage(with: temp[0].avatar, index: indexPath.row, completionHandler: { image, row in
            if row == indexPath.row {
                cell.userAvatar?.image = image
            }

        }, placeholderImage: nil)

            return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
