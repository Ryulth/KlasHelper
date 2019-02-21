//
//  ViewController.swift
//  KlasHelper
//
//  Created by 융미 on 08/02/2019.
//  Copyrigh/Users/yoonmee/Desktop/dev/Application/KlasHelperRemaster/frontend/ios/KlasHelper/HideShowPasswordTextField/HideShowPasswordTextField.swiftt © 2019 devOTTO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: HideShowPasswordTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPasswordTextField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}
// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, textField string: String) -> Bool {
        return passwordTextField.textField(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTextField.textFieldDidEndEditing(textField: textField)
    }
}

// MARK: Private helpers
extension ViewController {
    private func setupPasswordTextField() {
        passwordTextField.passwordDelegate = self as? HideShowPasswordTextFieldDelegate
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .none
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 0
        
        passwordTextField.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
        
        
        // left view hack to add padding
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 3))
        passwordTextField.leftViewMode = .always
        
        Alamofire.request(
            "http://klashelper.ryulth.com/login",
            method: .post,
            parameters: ["id":"__", "pw":"__"],
            encoding: JSONEncoding.default,
            headers: ["Content-Type":"application/json", "Accept":"application/json" , "appToken":"test"]
            )
            .validate(statusCode: 200..<300)
            .responseJSON {
                response in
                if let JSON = response.result.value {
                    print(JSON)
              
                }
        }
    }
}

//let MainUrl = "주소"
//
//func UploadComplete(PSubURL : String, User_id :String) -> (String, String){
//
//    //통신 함수
//
//    var SubURL  = PSubURL //서브주소
//
//    var Parameter = "?user_id="
//
//    var url:NSURL = NSURL(string: self.MainUrl + SubURL + Parameter + User_id)!
//
//    var PostValue:NSString = User_id
//
//    var post:NSString = "user_id=\(PostValue)"
//
//    var PostData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//
//    var postLength:NSString = String(PostData.length)
//
//    var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//
//
//
//    request.HTTPMethod = "POST"
//
//    request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//
//    request.setValue("application/x-www-form-rulencoded", forHTTPHeaderField: "Content-Type")
//
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//
//
//    var reponseError : NSError?
//
//    var response: NSURLResponse?
//
//    var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
//
//    let res = response as NSHTTPURLResponse!
//
//    if(res.statusCode == 200){
//
//        NSLog("Response code : %d", res.statusCode)
//
//
//
//        var TmpReq = NSString(data: urlData!, encoding: NSUTF8StringEncoding)
//
//        var Tmp = split(TmpReq as String, {$0 == ":"}, maxSplit: 1, allowEmptySlices: true)
//
//        var TmpHeader = Tmp[0].stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! //디코딩
//
//        var TmpContent = Tmp[1].stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! //디코딩
//
//        //            NSLog("TemHeader : " + TmpHeader)
//
//        //            NSLog("TemContent : " + TmpContent)
//
//        return (TmpHeader, TmpContent)
//
//    }
//
//    return ("Nil", "Nil")
//
//}

