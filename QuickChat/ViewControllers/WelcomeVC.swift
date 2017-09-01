//  Created by MyCom on 7/11/17.
//  Copyright © 2017 Mexonis. All rights reserved.


import UIKit
import Firebase
import Photos
import RSLoadingView

class WelcomeVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var registerView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var profilePicView: RoundedImageView!
    @IBOutlet weak var registerNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet var waringLabels: [UILabel]!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var cloudsView: UIImageView!
    @IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    @IBOutlet var inputFields: [UITextField]!
    
    //Loading View property
    let loadingView = RSLoadingView()
    
    var loginViewTopConstraint: NSLayoutConstraint!
    var registerTopConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var isLoginViewVisible = true
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Methods
    func customization()  {
        self.darkView.alpha = 0
        self.imagePicker.delegate = self
        self.profilePicView.layer.borderColor = GlobalVariables.blue.cgColor
        self.profilePicView.layer.borderWidth = 2
        //LoginView customization
        self.view.insertSubview(self.loginView, belowSubview: self.cloudsView)
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        self.loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginViewTopConstraint = NSLayoutConstraint.init(item: self.loginView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.loginViewTopConstraint.isActive = true
        self.loginView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        self.loginView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.loginView.layer.cornerRadius = 8
        //RegisterView Customization
        self.view.insertSubview(self.registerView, belowSubview: self.cloudsView)
        self.registerView.translatesAutoresizingMaskIntoConstraints = false
        self.registerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.registerTopConstraint = NSLayoutConstraint.init(item: self.registerView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.registerTopConstraint.isActive = true
        self.registerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6).isActive = true
        self.registerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.registerView.layer.cornerRadius = 8
    }
   
    func cloundsAnimation() {
        let distance = self.view.bounds.width - self.cloudsView.bounds.width
        self.cloudsViewLeading.constant = distance
        UIView.animate(withDuration: 15, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: { 
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LMSidebar") as! LMRootViewController
        self.show(vc1, sender: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func switchViews(_ sender: UIButton) {
        if self.isLoginViewVisible {
            self.isLoginViewVisible = false
            sender.setTitle("Sign in", for: .normal)
            self.loginViewTopConstraint.constant = 1000
            self.registerTopConstraint.constant = 60
        } else {
            self.isLoginViewVisible = true
            sender.setTitle("Sign up", for: .normal)
            self.loginViewTopConstraint.constant = 60
            self.registerTopConstraint.constant = 1000
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    @IBAction func register(_ sender: Any) {
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        self.showLoading(state: true)
        User.registerUser(withName: self.registerNameField.text!, email: self.registerEmailField.text!, password: self.registerPasswordField.text!, profilePic: self.profilePicView.image!) { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                    weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
                } else {
                    for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        
        self.showLoading(state: true)
        self.loadingView.show(on: view)
        
        User.loginUser(withEmail: self.loginEmailField.text!, password: self.loginPasswordField.text!) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                self.loadingView.hide()
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                } else {
                    for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }
                }
                weakSelf = nil
            }
        }
    }
    
    @IBAction func didRequestPasswordReset(_ sender: Any) {
        
        let prompt = UIAlertController(title: "Reset Password", message: "Please Input Email Address:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)

        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func selectPic(_ sender: Any) {
        
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    //MARK: Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePicView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cloundsAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cloudsViewLeading.constant = 0
        self.cloudsView.layer.removeAllAnimations()
        self.view.layoutIfNeeded()
    }
}
