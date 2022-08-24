//
//  PreviousScreenDummyViewController.swift
//  LeagueMobileChallenge
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

class PreviousScreenDummyViewController: UIViewController {
    
    @IBAction func gotoPost(_ sender: Any) {
        performSegue(withIdentifier: "PostSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostViewController {
            let service = NetworkCoordinator()
            destination.viewModel = PostViewControllerViewModel(service: service)
        }
    }
    
}
