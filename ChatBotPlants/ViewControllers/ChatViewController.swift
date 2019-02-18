//
//  ChatViewController.swift
//  ChatBotPlants
//
//  Created by Francesca Valeria Haro Dávila on 2/18/19.
//  Copyright © 2019 Belatrix. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ApiAI
//import Speech

//enum ChatWindowStatus
//{
//  case minimised
//  case maximised
//}

class ChatViewController: JSQMessagesViewController {
  
  var messages = [JSQMessage]()
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
//  lazy var speechSynthesizer = AVSpeechSynthesizer()
  lazy var botImageView = UIImageView()
  
//  var chatWindowStatus : ChatWindowStatus = .maximised
//  var botImageTapGesture: UITapGestureRecognizer?
//

  override func viewDidLoad() {
    super.viewDidLoad()
    self.senderId = "some userId"
    self.senderDisplayName = "some userName"

//    SpeechManager.shared.delegate = self
//    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
//    self.view.addGestureRecognizer(swipeGesture)
//    self.addMicButton()
    
    // No avatars
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
//    if #available(iOS 11.0, *) {
//      collectionView.contentInset.bottom = 0
//      collectionView.contentInset.top = 0
//    }
    
    let deadlineTime = DispatchTime.now() + .seconds(0)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
      self.populateWithWelcomeMessage()
    })
  }

  //MARK: Helper Methods
//  func addMicButton()
//  {
//    let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
//    let micButton = UIButton(type: .custom)
//    micButton.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
//    micButton.frame = CGRect(x: 0, y: 0, width: 25, height: height)
//
//    self.inputToolbar.contentView.leftBarButtonItemWidth = 25
//    self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(micButton)
//    self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
//
////    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOfMic(gesture:)))
////    micButton.addGestureRecognizer(longPressGesture)
//  }
//
  func populateWithWelcomeMessage()
  {
    self.addMessage(withId: "BotId", name: "Bot", text: "Bienvenido")
    self.finishReceivingMessage()
    self.addMessage(withId: "BotId", name: "Bot", text: "¿En que puedo ayudarte?")
    self.finishReceivingMessage()
  }
  
  private func addMessage(withId id: String, name: String, text: String) {
    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
      messages.append(message)
    }
  }
  

  //MARK: Core Functionality
  func performQuery(senderId:String,name:String,text:String)
  {
    let request = ApiAI.shared().textRequest()
    if text != "" {
      request?.query = text
    } else {
      return
    }
    
    
    request?.setMappedCompletionBlockSuccess({ (request, response) in
      let response = response as! AIResponse
      if response.result.action == "tell.about"
      {
        if let parameters = response.result.parameters as? [String:AIResponseParameter]
        {
          if let about = parameters["about"]?.stringValue
          {
            switch about
            {
            case "Kings":
              print("Kings")
            case "Heat":
              print("Heat")
            default:
              print("Default")
            }
          }
        }
      }
      else if response.result.action == "tell.stats"
      {
        if let parameters = response.result.parameters as? [String:AIResponseParameter]
        {
          if let stats = parameters["stats"]?.stringValue
          {
            switch stats
            {
            case "Lead":
              print("Lead")
            default:
              print("Default")
            }
          }
        }
      }
      else if response.result.action == "bot.capabilities"
      {
        if let parameters = response.result.parameters as? [String:AIResponseParameter]
        {
          if let capabilities = parameters["capabilities"]?.stringValue
          {
            switch capabilities
            {
            case "multimedia":
              print("multimedia")
            default:
              print("Default")
            }
          }
        }
      }
      else if response.result.action == "bot.quit"
      {
        if let parameters = response.result.parameters as? [String:AIResponseParameter]
        {
          if let quit = parameters["quit"]?.stringValue
          {
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
              //self.minimiseBot()
            })
          }
        }
      }
      else
      {
        print("Unknown")
      }
      
      if let textResponse = response.result.fulfillment.speech
      {
        //SpeechManager.shared.speak(text: textResponse)
        self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
        self.finishReceivingMessage()
      }
    }, failure: { (request, error) in
      print(error)
    })
    ApiAI.shared().enqueue(request)
  }
  
  //MARK: JSQMessageViewController Methods
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  }
  
  private func setupIncomingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item] // 1
    if message.senderId == senderId { // 2
      return outgoingBubbleImageView
    } else { // 3
      return incomingBubbleImageView
    }
  }
  
  //removing avatars
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    let message = messages[indexPath.item]
    
    if message.senderId == senderId {
      cell.textView?.textColor = UIColor.white
    } else {
      cell.textView?.textColor = UIColor.black
    }
    return cell
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    
    addMessage(withId: senderId, name: senderDisplayName!, text: text!)
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    finishSendingMessage()
    performQuery(senderId: senderId, name: senderDisplayName, text: text!)
    
  }
  
  override func didPressAccessoryButton(_ sender: UIButton)
  {
    performQuery(senderId: senderId, name: senderDisplayName, text: "Multimedia")
    
  }
}

