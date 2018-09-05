//
//  ChatBot.swift
//  Clerkie App
//
//  Created by Ram Sri Charan on 9/2/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import Foundation
import UIKit

class ChatBot {
    
    // Search Keywords
    fileprivate let GREETING_KEYWORDS = ["hello", "hi", "hey", "what's up?", "hello there", "wassup"]
    fileprivate let QUESTIONS_KEYWORDS = [ "what", "how", "when", "where"]
    fileprivate let FUN_KEYWORDS = [":)", ":d", "lol", "funny", "haha", "jk", "just kidding", "hehe" ]
    fileprivate let VERB_KEYWORDS = ["doing", "happening", "going"]
    fileprivate let APOLOGIES_KEYWORD = ["sorry", "my bad"]
    
    
    // Responses
    fileprivate let GREETING_RESPONSE = ["Hello! Hope you are doing great", "Hey, Wassup", "Hi!!!! Thanks for texting me"]
    fileprivate let APOLOGIES_RESPONSE = ["No Problem", "No worries", "Not at all an issue", "It's Alright"]
    fileprivate let DEFAULT_RESPONSE = ["Hmm...", "I don't know what to say", ":)"]
    fileprivate let FUN_RESPONSE = ["Haha!! That's funny", "HAHAHAHA..!", "OMG.. You are so funny!", "That's Hilarious!!"]
    fileprivate let PHOTO_RESPONSE = ["That's a nice photo", "Wow..! Amazing pic", "Cool Picture!", "Nice Click", "Thanks for sharing such an awesome picture with me"]
    fileprivate let VIDEO_RESPONSE = ["That's an interesting video", "Nice Video", "Wow.. That's a cool clip"]
    
    
    // Gives response to the users input
    func getResponse(message : String) -> String
    {
        let receivedMessage = message.lowercased()
        var response = ""
        
        let isGreeting = GREETING_KEYWORDS.contains(where: receivedMessage.contains)
        let isQuestion = QUESTIONS_KEYWORDS.contains(where: receivedMessage.contains)
        let isApology = APOLOGIES_KEYWORD.contains(where: receivedMessage.contains)
        let isFunny = FUN_KEYWORDS.contains(where: receivedMessage.contains)
        
        
        if(isGreeting)
        {
            
            response.append("\(GREETING_RESPONSE.randomElement()). ")
        }
        
        if(isApology)
        {
            response.append("\(APOLOGIES_RESPONSE.randomElement()). ")
        }
        
        if(isFunny)
        {
            response.append("\(FUN_RESPONSE.randomElement()). ")
        }
        
        if(isQuestion)
        {
            response.append("My bad I am not yet prepared to answer questions..")
        }
        
        if(response.isEmpty)
        {
            response.append("\(DEFAULT_RESPONSE.randomElement()).")
        }
        
        return response
    }
    
    
    
    // Responding to Photo messages
    func respondToPhoto() -> String
    {
        return PHOTO_RESPONSE.randomElement()
    }
    
    // Responding to Video Messages
    func respondToVideo() -> String
    {
        return VIDEO_RESPONSE.randomElement()
    }
    
    
    
    
}





extension Array {

    func randomElement() -> Element
    {
        let number = Int(arc4random_uniform(UInt32(self.count - 1)))
        return self[number]
    }
}



