//
//  ViewController.swift
//  ChatBotPlants
//
//  Created by Francesca Valeria Haro Dávila on 2/18/19.
//  Copyright © 2019 Belatrix. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
  }
  
//  override func viewDidAppear(_ animated: Bool) {
//
//    let chatVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as? ChatViewController
//
//    UIView.animate(withDuration: 0.5) {
//      chatVc?.view.frame = CGRect(x: self.view.frame.origin.x, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 20)
//      self.view.addSubview((chatVc?.view)!)
//      self.addChild(chatVc!)
//      self.didMove(toParent: chatVc)
//    }
//
//  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
