//
//  QuestionVC.swift
//  QuickChat
//
//  Created by MyCom on 7/8/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class QuestionVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var musicValue: NoCopyPasteUITextField!
    @IBOutlet weak var datingValue: NoCopyPasteUITextField!
    @IBOutlet weak var lifestyleValue: NoCopyPasteUITextField!
    @IBOutlet weak var careertypeValue: NoCopyPasteUITextField!
    @IBOutlet weak var lifemottoValue: NoCopyPasteUITextField!
    @IBOutlet weak var manualItemValue: NoCopyPasteUITextField!
    
    @IBOutlet var inputValueFields: [UITextField]!
    
    @IBOutlet weak var musicTable: UITableView!
    @IBOutlet weak var musicTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datingTable: UITableView!
    @IBOutlet weak var datingTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lifestyleTable: UITableView!
    @IBOutlet weak var lifestyleTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var careertypeTable: UITableView!
    @IBOutlet weak var careertypeTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lifemottoTable: UITableView!
    @IBOutlet weak var lifemottoTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var manualItemTable: UITableView!
    @IBOutlet weak var manualItemTableHeightConstraint: NSLayoutConstraint!
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(QuestionVC.sideBarMenu))
        return button
    }()
    
    let musicCellReuseIdentifier = "musicCell"
    let datingCellReuseIdentifier = "datingCell"
    let lifestyleCellReuseIdentifier = "lifestyleCell"
    let careertypeCellReuseIdentifier = "careertypeCell"
    let lifemottoCellReuseIdentifier = "lifemottoCell"
    let manualItemCellReuseIdentifier = "manualItemCell"
    
    var musicValueComponent = ["Jazz", "Hip-Hop", "R & B_music", "Regional Mexican", "Classical", "Pop", "Rock n Roll", "Blues", "Independent", "Latin", "Dance electric", "Easy listening", "Reggae", "Techno", "Melody", "Folk", "Oldies 70’s, 80’s & 90’s", "Funk disco", "Opera", "Soul", "Gospel", "Religious", "Punk", "World", "Indie rock", "Death Metal"]
    
    var datingValueComponent = ["The Flirt", "The Friend", "Honest & Integrity", "Committed", "Just here", "Openness", "Affectionate", "The giver", "Respect & independence", "Sense a humor", "The Learner", "Adventurer", "The controller", "Hopeless Romantic", "Gothic-lite", "The old-fashion", "The Rebound", "The wine tasters", "The drinkers"]
    
    var lifestyleValueComponent = ["The consumer", "Animal Lover", "Healthy", "The Yogies", "Gym Rat", "Workaholic", "Fast cars", "Nice cars", "Chilled", "Indifferent", "Spontaneous", "Wild n Crazy", "Fun and outgoing", "Slow & steady", "Focused", "The road Tripper", "Peacemaker", "Foodies", "The cooker", "The baker", "The actor", "Adventuresses", "The Golfer", "Movie Goer", "Netflix kicker", "Coffee goer", "Nespresso goer", "Socialite", "The Walker", "The Runner", "The Performers", "Drama club", "Cyclist", "Pedal pushers", "Bikers", "The swimmer", "The Vegan", "The minimalist", "The Churchgoer", "The evangelist", "The missionaries", "Jehovah witness", "The weight watcher", "The student", "The reader"]

    
    var careertypeValueComponent = ["The entrepreneur", "The businessman", "The trainer", "The banker", "The teacher", "The engineer", "The student", "The Vet", "The Librarian", "The Doctor", "The Nurse", "The Mechanic", "The painter", "The manager", "The educator", "The chef", "Pre-chef", "The Lawyer", "The Judge", "The Officer", "Drivers", "Truckers", "The scientist", "The chemist", "The dentist", "The architect", "The Pilot", "The stewardesses", "The Cleaners"]
   
    var lifemottoValueComponent = ["Yolo", "Learning every day new things", "Live simply", "The less you have the more have", "Feel the fear and do it anyways", "No risk no reward", "One day at a time", "Your not happy at home; your not happy anywhere else", "Laissez – Let it be", "I am not accepting things I cannot change but changing things I cannot accept"]
    
//    var manualItemValueComponent = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeyboardAvoiding.avoidingView = self.questionView
        
        self.navigationItem.leftBarButtonItem = self.leftButton

        // Do any additional setup after loading the view.
        
        self.musicTable.register(UITableViewCell.self, forCellReuseIdentifier: musicCellReuseIdentifier)
        
        musicTable.delegate = self
        musicTable.dataSource = self
        musicTable.isHidden = true
        musicValue.delegate = self
        
        musicValue.addTarget(self, action: #selector(musicTextFieldActive), for: UIControlEvents.touchDown)
        
        self.datingTable.register(UITableViewCell.self, forCellReuseIdentifier: datingCellReuseIdentifier)
        
        datingTable.delegate = self
        datingTable.dataSource = self
        datingTable.isHidden = true
        datingValue.delegate = self
        
        datingValue.addTarget(self, action: #selector(datingTextFieldActive), for: UIControlEvents.touchDown)
        
        self.lifestyleTable.register(UITableViewCell.self, forCellReuseIdentifier: lifestyleCellReuseIdentifier)
        
        lifestyleTable.delegate = self
        lifestyleTable.dataSource = self
        lifestyleTable.isHidden = true
        lifestyleValue.delegate = self
        
        lifestyleValue.addTarget(self, action: #selector(lifestyleTextFieldActive), for: UIControlEvents.touchDown)
        
        self.careertypeTable.register(UITableViewCell.self, forCellReuseIdentifier: careertypeCellReuseIdentifier)
        
        careertypeTable.delegate = self
        careertypeTable.dataSource = self
        careertypeTable.isHidden = true
        careertypeValue.delegate = self
        
        careertypeValue.addTarget(self, action: #selector(careertypeTextFieldActive), for: UIControlEvents.touchDown)
        
        self.lifemottoTable.register(UITableViewCell.self, forCellReuseIdentifier: lifemottoCellReuseIdentifier)
        
        lifemottoTable.delegate = self
        lifemottoTable.dataSource = self
        lifemottoTable.isHidden = true
        lifemottoValue.delegate = self
        
        lifemottoValue.addTarget(self, action: #selector(lifemottoTextFieldActive), for: UIControlEvents.touchDown)
        
        self.fetchUserQuestionnaire()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        musicTableHeightConstraint.constant = 200
        datingTableHeightConstraint.constant = 200
        lifestyleTableHeightConstraint.constant = 200
        careertypeTableHeightConstraint.constant = 200
        lifemottoTableHeightConstraint.constant = 200
//        lifemottoTableHeightConstraint.constant = lifemottoTable.contentSize.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        
        if (touch.view !== musicTable){
            
            musicValue.endEditing(true)
            musicTable.isHidden = true
            
        }
        if (touch.view !== lifemottoTable){
            
            lifemottoValue.endEditing(true)
            lifemottoTable.isHidden = true
            
        }
        if (touch.view !== datingTable){
            
            datingValue.endEditing(true)
            datingTable.isHidden = true
            
        }
        if (touch.view !== lifestyleTable){
            
            lifestyleValue.endEditing(true)
            lifestyleTable.isHidden = true
        }
        if (touch.view !== careertypeTable){
            
            careertypeValue.endEditing(true)
            careertypeTable.isHidden = true
            
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        KeyboardAvoiding.avoidingView = self.questionView
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textfield finishes editing
        
        print("The textfield ended editing. Do something based on app requirements.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    
    func fetchUserQuestionnaire(){
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("questionnaire").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                self.musicValue.text = data["Music"]!
                self.datingValue.text = data["Dating"]!
                self.lifestyleValue.text = data["Lifestyle"]!
                self.careertypeValue.text = data["Careertype"]!
                self.lifemottoValue.text = data["Lifemotto"]!
                self.manualItemValue.text = data["ManualItem"]!
                
            }
        })
        
        
    }
    
    
    @IBAction func questionnaireSave(_ sender: Any) {
        
        for item in self.inputValueFields {
            item.resignFirstResponder()
        }
        
        let questionnaireValues = ["Music": self.musicValue.text, "Dating": self.datingValue.text, "Lifestyle": self.lifestyleValue.text, "Careertype": self.careertypeValue.text, "Lifemotto": self.lifemottoValue.text, "ManualItem": self.manualItemValue.text]
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("questionnaire").updateChildValues(questionnaireValues, withCompletionBlock: { (errr, _) in
            if errr == nil {
                
            }else{
                
            }
        })
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Navigation") as! NavVC
//        self.present(nextViewController, animated:true, completion:nil)
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LMSidebar") as! LMRootViewController
        self.present(vc1, animated:true, completion:nil)
        
    }
    
    
    
    
    
    
    func musicTextFieldActive(){
        musicTable.isHidden = !musicTable.isHidden
    }
    
    func datingTextFieldActive(){
        datingTable.isHidden = !datingTable.isHidden
    }
    
    func lifestyleTextFieldActive(){
        lifestyleTable.isHidden = !lifestyleTable.isHidden
    }
    
    func careertypeTextFieldActive(){
        careertypeTable.isHidden = !careertypeTable.isHidden
    }
    
    func lifemottoTextFieldActive(){
        lifemottoTable.isHidden = !lifemottoTable.isHidden
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == musicTable){
            return musicValueComponent.count
        }else if(tableView == lifemottoTable){
            return lifemottoValueComponent.count
        }else if(tableView == datingTable){
            return datingValueComponent.count
        }else if(tableView == lifestyleTable){
            return lifestyleValueComponent.count
        }else if(tableView == careertypeTable){
            return careertypeValueComponent.count
        }else{
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == musicTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: musicCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = musicValueComponent[indexPath.row]
            cell.textLabel?.font = musicValue.font
            
            return cell
        }else if(tableView == lifemottoTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: lifemottoCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = lifemottoValueComponent[indexPath.row]
            cell.textLabel?.font = lifemottoValue.font
            
            return cell
        }else if(tableView == datingTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: datingCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = datingValueComponent[indexPath.row]
            cell.textLabel?.font = datingValue.font
            
            return cell
            
        }else if(tableView == lifestyleTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: lifestyleCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = lifestyleValueComponent[indexPath.row]
            cell.textLabel?.font = lifestyleValue.font
            
            return cell
            
        }else if(tableView == careertypeTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: careertypeCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = careertypeValueComponent[indexPath.row]
            cell.textLabel?.font = careertypeValue.font
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: manualItemCellReuseIdentifier, for: indexPath as IndexPath)
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == musicTable){
            
            musicValue.text = musicValueComponent[indexPath.row]
            tableView.isHidden = true
            musicValue.endEditing(true)
            
        }else if(tableView == lifemottoTable){
            
            lifemottoValue.text = lifemottoValueComponent[indexPath.row]
            tableView.isHidden = true
            lifemottoValue.endEditing(true)
    
        }else if(tableView == datingTable){
            
            datingValue.text = datingValueComponent[indexPath.row]
            tableView.isHidden = true
            datingValue.endEditing(true)
            
        }else if(tableView == lifestyleTable){
            
            lifestyleValue.text = lifestyleValueComponent[indexPath.row]
            tableView.isHidden = true
            lifestyleValue.endEditing(true)
            
        }else if(tableView == careertypeTable){
            
            careertypeValue.text = careertypeValueComponent[indexPath.row]
            tableView.isHidden = true
            careertypeValue.endEditing(true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }

    
    
}
