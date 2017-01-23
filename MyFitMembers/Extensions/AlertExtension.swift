//
//  AlertExtension.swift
//  Sex Challenge
//
//  Created by CB Macmini_3 on 05/12/15.
//  Copyright © 2015 Rico. All rights reserved.
//



extension UIAlertController{
    
    
    class func showAlertController(title title : String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: "" , preferredStyle: UIAlertControllerStyle.Alert)
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        
        controller.addAction(yes)
        controller.addAction(no)
        return controller
    }
    
    
    class func showActionSheetController(title title : String? , buttons : [String] , success : (String) -> ()) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: "" , preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for btn in buttons{
            let action = UIAlertAction(title: btn, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                success(btn)
            })
            controller.addAction(action)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "")
        , style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        controller.addAction(cancel)
        return controller
    }
    
    class func showAlertControllerWithTextField(title title : String,placeholder : String, success : (String?) -> () , failure : () -> ()) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: "" , preferredStyle: UIAlertControllerStyle.Alert)
        controller.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = placeholder
            textField.returnKeyType = .Done
            textField.keyboardType = .EmailAddress
            textField.addTarget(self, action: Selector("textFieldValueChanged:"), forControlEvents: .ValueChanged)
        }
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let tfEmail = controller.textFields?.first
            success(tfEmail?.text)
        }
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (action) -> Void in
            failure()
        }
        
        controller.addAction(yes)
        controller.addAction(no)
        return controller
    }
    
    func textFieldValueChanged(sender : UITextField){
        
        if let alert = self.presentedViewController as? UIAlertController {
            
            let email = alert.textFields?.first
            let okAction = alert.actions.last
            okAction?.enabled = email?.text?.characters.count > 1
        }
        if sender.text == "\n" {
            sender.resignFirstResponder()
        }
    }
}
