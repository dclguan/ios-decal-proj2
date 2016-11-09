//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var fullWord = String()
    var currWord = String()
    var incorrectGuessList: [String] = []
    var gameFinished: Bool = false

    @IBOutlet weak var hangman: UIImageView!
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var hangmanWord: UILabel!
    @IBOutlet weak var guessChar: UITextField!
    @IBOutlet weak var startOver: UIButton!
    @IBOutlet weak var answer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func makeGuess(sender: UIButton) {
        if gameFinished {
            return
        }
        let guess = guessChar.text?.uppercased()
        if guess?.characters.count == 1, let _ = guess?.rangeOfCharacter(from: NSCharacterSet.letters){
            var correct: Bool = false
            
            var temp = ""
            for i in self.fullWord.characters.indices {
                if String(self.fullWord[i]) == guess {
                    correct = true
                    temp += guess!
                } else {
                    temp += String(self.currWord.characters[i])
                }
            }
            
            hangmanWord.text = temp
            self.currWord = hangmanWord.text!
            
            if !correct {
                var incorrectLabelList = incorrectGuesses.text!
                if !self.incorrectGuessList.contains(guess!) {
                    incorrectLabelList += " " + guess!
                    self.incorrectGuessList.append(guess!)
                }
                
                let newImage = "hangman" + String(self.incorrectGuessList.count + 1) + ".gif"
                hangman.image = UIImage(named: newImage)
                incorrectGuesses.text = incorrectLabelList
                
                if (self.incorrectGuessList.count >= 6) {
                    lose()
                }
            } else {
                if hangmanWord.text == self.fullWord {
                    win()
                }
            }
            guessChar.text = ""
        } else {
            let alertController = UIAlertController(title:"annoying reminder", message: "1 letter please", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func win() {
        self.gameFinished = true
        let alertController = UIAlertController(title:"winner", message: "gg ez", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        startOver.isHidden = false
        guessChar.isEnabled = false
    }
    
    func lose() {
        self.gameFinished = true
        let alertController = UIAlertController(title:"loser", message: "unlucky", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        startOver.isHidden = false
        guessChar.isEnabled = false
        answer.isHidden = false
        answer.text = "Answer: " + self.fullWord
    }
    
    @IBAction func prepNewGame(sender: UIButton) {
        newGame()
        
    }
    
    func newGame() {
        resetValues()
        
        startOver.isHidden = true
        answer.isHidden = true
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase!)
        
        for char in (phrase?.characters)! {
            if char == " " {
                self.currWord += "  "
            } else {
                self.currWord += "_ "
            }
            self.fullWord += String(char) + " "
        }
        
        hangmanWord.text = self.currWord
        
        let image = "hangman1.gif"
        hangman.image = UIImage(named: image)
        guessChar.isEnabled = true
        guessChar.text = ""
    }
    
    func resetValues() {
        self.currWord = ""
        self.fullWord = ""
        self.incorrectGuessList = []
        self.gameFinished = false
        
        incorrectGuesses.text = "Incorrect Guesses:"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
