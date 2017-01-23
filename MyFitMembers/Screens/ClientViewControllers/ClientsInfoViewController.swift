//
//  ClientInfoViewController.swift
//  MyFitMembers
//
//  Created by cbl24 on 9/27/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientsInfoViewController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate , DateOfBirthClicked , SetDate{
    
    
    //MARK::- Outlets
    
    @IBOutlet weak var labelUserName: UITextField!{
        didSet{
            labelUserName.text = UserDataSingleton.sharedInstance.loggedInUser?.name
        }
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = imageUser.frame.height/2
        }
    }
    @IBOutlet weak var viewContentView: UIView!
    @IBOutlet weak var btnPersonalInfo: UIButton!
    @IBOutlet weak var btnFitnessInfo: UIButton!
    @IBOutlet weak var viewFloatingFitnessInfo: UIView!
    @IBOutlet weak var viewFloatingPersonalInfo: UIView!
    
    //MARK::- Variables
    var clientPersonalInfo: ClientPersonalInfoViewController?
    var clientSettings: ClientSettingsViewController?
    var trainerProfileVc: TrainerProfileViewController?
    var trainerSettingsVc: TrainerSettingsViewController?
    
    var viewControllerArray:NSArray? = []
    var pageController : UIPageViewController?
    var blackColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.88)
    var greyColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.44)
    var edit = true
    var dateChooserView: DateChooser?
    var boolBlockApi = false
    //MARK::- Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFloatingFitnessInfo.hidden = true
        instantiateViewControllers()
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            setUp(clientPersonalInfo)
        }else{
            guard let trainerProfileVc = trainerProfileVc else {return}
            setUp(trainerProfileVc)
        }
        imageUser.layer.cornerRadius = imageUser.frame.height/2
        setUpSideBar(false,allowRighSwipe: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if boolBlockApi{
            boolBlockApi = false
            
        }else{
            boolBlockApi = false
            getPersonalDetails(false)
        }
        
        if edit{
            btnEdit.setImage(UIImage(named: "ic_edit_white"), forState: .Normal)
            btnEdit.setTitle("", forState: .Normal)
            
        }else{
            btnEdit.setTitle("SAVE", forState: .Normal)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK::- DELEGATE
    
    func showDatePicker(){
        view.endEditing(true)
        showAnimate(dateChooserView ?? UIView() )
        self.view.addSubview(dateChooserView ?? UIView())
    }
    
    func setDate(date:String){
        guard let vc = clientPersonalInfo else {return}
        guard let cell = vc.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ClientPersonalInfoTableViewCell else {return}
        cell.labelAge.text = date
    }
    
    //MARK::- Functions
    func instantiateViewControllers(){
        clientPersonalInfo = StoryboardScene.ClientStoryboard.instantiateClientPersonalInfoViewController()
        clientPersonalInfo?.delegate = self
        clientSettings = StoryboardScene.ClientStoryboard.instantiateClientSettingsViewController()
        trainerProfileVc = StoryboardScene.Main.instantiateTrainerProfileViewController()
        trainerSettingsVc = StoryboardScene.Main.instantiateTrainerSettingsViewController()
        dateChooserView = DateChooser(frame: CGRectMake(0, 0, DeviceDimensions.width, DeviceDimensions.height))
        dateChooserView?.delegate = self
    }
    
    func upadteData(){
        imageUser.layer.cornerRadius = imageUser.frame.height/2
        let imgUrl = UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage
        let imageUrl = NSURL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
        imageUser.yy_setImageWithURL(imageUrl, placeholder: UIImage(named: "ic_placeholder"))
        labelUserName.text = UserDataSingleton.sharedInstance.loggedInUser?.name?.uppercaseFirst
    }
    
    func setUp(firstViewControl: UIViewController){
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo , clientSettings = clientSettings else {return}
            viewControllerArray = [clientPersonalInfo,clientSettings]
        }else{
            guard let trainerProfileVc = trainerProfileVc , trainerSettingsVc = trainerSettingsVc else {return}
            viewControllerArray = [trainerProfileVc, trainerSettingsVc]
        }
        pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController?.setViewControllers([firstViewControl], direction: .Forward, animated: true, completion: nil)
        pageController?.view.frame = CGRectMake(0, 0, viewContentView.bounds.width, viewContentView.bounds.height)
        pageController?.delegate = self
        pageController?.dataSource = self
        guard let pageController = pageController else{return}
        self.addChildViewController(pageController)
        self.viewContentView.addSubview(pageController.view)
        self.pageController?.didMoveToParentViewController(self)
    }
    
    func setViewController(vc:UIViewController, sender:UIButton){
        if(sender.tag == 0){
            self.pageController?.setViewControllers([vc], direction: .Reverse, animated: true, completion: nil)
        }else{
            self.pageController?.setViewControllers([vc], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    //MARK::- PAGEVIEWCONTROLLER DELEGATE
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return UIViewController() }
        if isClient{
            if viewController .isKindOfClass(ClientPersonalInfoViewController) {
                return clientSettings
            }else{
                return nil
            }
        }else{
            if viewController .isKindOfClass(TrainerProfileViewController) {
                return trainerSettingsVc
            }else{
                return nil
            }
        }
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return UIViewController() }
        if isClient{
            if viewController .isKindOfClass(ClientSettingsViewController) {
                return clientPersonalInfo
            }else{
                return nil
            }
            
        }else{
            if viewController .isKindOfClass(TrainerSettingsViewController) {
                return trainerProfileVc
            }else{
                return nil
            }
            
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed{
            guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
            
            if isClient{
                if previousViewControllers.first is ClientPersonalInfoViewController{
                    viewFloatingPersonalInfo.hidden = true
                    viewFloatingFitnessInfo.hidden = false
                    btnFitnessInfo.setTitleColor(blackColor, forState: .Normal)
                    btnEdit.hidden = true
                    btnPersonalInfo.setTitleColor(greyColor, forState: .Normal)
                }else{
                    viewFloatingPersonalInfo.hidden = false
                    btnPersonalInfo.setTitleColor(blackColor, forState: .Normal)
                    btnEdit.hidden = false
                    btnFitnessInfo.setTitleColor(greyColor, forState: .Normal)
                    viewFloatingFitnessInfo.hidden = true
                }
            }else{
                if previousViewControllers.first is TrainerProfileViewController{
                    viewFloatingPersonalInfo.hidden = true
                    viewFloatingFitnessInfo.hidden = false
                    btnFitnessInfo.setTitleColor(blackColor, forState: .Normal)
                    btnEdit.hidden = true
                    btnPersonalInfo.setTitleColor(greyColor, forState: .Normal)
                }else{
                    viewFloatingPersonalInfo.hidden = false
                    btnPersonalInfo.setTitleColor(blackColor, forState: .Normal)
                    btnEdit.hidden = false
                    btnFitnessInfo.setTitleColor(greyColor, forState: .Normal)
                    viewFloatingFitnessInfo.hidden = true
                }
            }
            
        }
        
        
    }
    
    //MARK::- Actions
    
    @IBAction func btnActionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionPersonalInfo(sender: UIButton) {
        btnEdit.hidden = false
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
        sender.setTitleColor(blackColor, forState: .Normal)
        btnFitnessInfo.setTitleColor(greyColor, forState: .Normal)
        viewFloatingPersonalInfo.hidden = false
        viewFloatingFitnessInfo.hidden = true
        sender.tag = 0
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            setViewController(clientPersonalInfo, sender: sender)
        }else{
            guard let trainerProfileVc = trainerProfileVc else {return}
            setViewController(trainerProfileVc, sender: sender)
        }
        
        
    }
    
    @IBAction func btnActionFitnessInfo(sender: UIButton) {
        btnEdit.hidden = true
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
        
        sender.tag = 1
        sender.setTitleColor(blackColor, forState: .Normal)
        viewFloatingPersonalInfo.hidden = true
        viewFloatingFitnessInfo.hidden = false
        btnPersonalInfo.setTitleColor(greyColor, forState: .Normal)
        if isClient{
            guard let clientSettings = clientSettings else {return}
            setViewController(clientSettings, sender: sender)
        }else{
            guard let trainerSettingsVc = trainerSettingsVc else {return}
            setViewController(trainerSettingsVc, sender: sender)
        }
        
        
    }
    
    
    @IBAction func btnActionEdit(sender: UIButton) {
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if edit{
            edit = false
            labelUserName.enabled = false
            guard let trainerProfileVc = trainerProfileVc else {return}
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            if isClient{
                guard let cell = clientPersonalInfo.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ClientPersonalInfoTableViewCell else {return}
                cell.labelEmail.enabled = true
                cell.labelAddress.enabled = true
                cell.labelPhoneNumber.enabled = true
                cell.labelName.enabled = true
                cell.textFieldPinCode.enabled = true
                cell.textFieldCity.enabled = true
                cell.btnDate.enabled = true
                cell.btnState.enabled = true
            }else{
                labelUserName.enabled = true
                guard let cell = trainerProfileVc.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TrainerProfileTableViewCell else {return}
                cell.labelEmailId.enabled = true
                cell.labelAddress.enabled = true
                cell.labelPhoneNumber.enabled = true
                cell.textFieldZipCode.enabled = true
                cell.textFieldCity.enabled = true
                cell.btnState.enabled = true
            }
            sender.setTitle("SAVE", forState: .Normal)
            sender.setImage(UIImage(), forState: .Normal)
        }else{
            
            if isClient{
                editDetailOfClient()
            }else{
                
                editDetails()
            }
            
            
            
        }
        
        
        
    }
    
    
    
}


extension ClientsInfoViewController{
    
    //MARK::- CAMERA
    func callFusumaImagePicker(item:String){
        allowRev = false
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            print(image)
            self?.imageUser.image = image
            }, canceledListner: {} , allowEditting:true)
        
    }
    
    //MARK::- API
    
    func editDetailOfClient(){
        
        
        guard let clientPersonalInfo = clientPersonalInfo else {return}
        guard let cell = clientPersonalInfo.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ClientPersonalInfoTableViewCell else {return}
        
        guard let usrName = cell.labelName.text?.lowercasedFirst() else {
            AlertView.callAlertView("", msg: "Please enter name", btnMsg: "OK", vc: self)
            return}
        let names = usrName.split(" ")
        var firstName = ""
        var lastName = ""
        if names.count == 2{
            firstName = names[0].lowercasedFirst()
            lastName = names[1].uppercaseFirst
        }else{
            firstName = usrName
        }
        
        let _ = ClientEditDetails(firstName: firstName, lastName: lastName, phoneNumber: cell.labelPhoneNumber.text, countryCode: "+1", address: cell.labelAddress.text, email: cell.labelEmail.text, pinCode: cell.textFieldPinCode.text, state: cell.btnState.titleLabel?.text, city: cell.textFieldCity.text)
        let checkValidation = ClientEditDetails.getValidationResult()
        
        if checkValidation{
            var dictForBackEnd = createdDict
            
            dictForBackEnd?["age"] = cell.labelAge.text
            
            print(dictForBackEnd)
            
            ApiDetector.getDataOfURL(ApiCollection.apiClientSaveEditting, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [weak self] (data) in
                    print(data)
                    guard let cell = clientPersonalInfo.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? ClientPersonalInfoTableViewCell else {return}
                    cell.labelEmail.enabled = false
                    cell.btnDate.enabled = false
                    cell.labelAddress.enabled = false
                    cell.labelPhoneNumber.enabled = false
                    cell.labelName.enabled = false
                    cell.textFieldPinCode.enabled = false
                    cell.textFieldCity.enabled = false
                    cell.btnState.enabled = false
                    self?.labelUserName.enabled = false
                    self?.labelUserName.text = firstName.uppercaseFirst + " " + lastName.uppercaseFirst
                    self?.edit = true
                    self?.btnEdit.setImage(UIImage(named: "ic_edit_white"), forState: .Normal)
                    self?.btnEdit.setTitle("", forState: .Normal)
                    clientPersonalInfo.getPersonalDetails(false)
                    self?.getPersonalDetails(false)
                    AlertView.callAlertView("", msg: "Changes successfully saved.", btnMsg: "OK", vc: self ?? UIViewController())
                }, method: .PostWithImage, viewControl: self, pic: self.imageUser.image, placeHolderImageName: "profilePic", headers: [:], showLoader: true, loaderColor: Colorss.DarkRed.toHex())
            
        }else{
            AlertView.callAlertView("", msg: "Please enter complete and valid information", btnMsg: "OK", vc: self)
        }
        
    }
    
    
    func editDetails(){
        
        guard let trainerProfileVc = trainerProfileVc else {return}
        guard let cell = trainerProfileVc.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? TrainerProfileTableViewCell else {return}
        
        
        
        //        guard let phnNo = cell.labelPhoneNumber.text?.uppercaseFirst else{
        //            AlertView.callAlertView("", msg: "Please enter valid phoneNumber", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if phnNo == ""{
        //            AlertView.callAlertView("", msg: "Please enter valid phoneNumber", btnMsg: "OK", vc: self)
        //            return
        //        }else{
        //
        //        }
        //
        //
        //        guard let address = cell.labelAddress.text else{
        //            AlertView.callAlertView("", msg: "Please enter address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //
        //        if address == ""{
        //            AlertView.callAlertView("", msg: "Please enter address", btnMsg: "OK", vc: self)
        //            return
        //        }else{
        //
        //        }
        guard var usrName = labelUserName.text?.lowerCaseFirst else {return}
        
        if usrName == ""{
            AlertView.callAlertView("", msg: "Please enter name", btnMsg: "OK", vc: self)
            return
        }
        
        var names = usrName.split(" ")
        var firstName = ""
        var lastName = ""
        if names.count == 2{
            firstName = names[0].lowerCaseFirst
            lastName = names[1].uppercaseFirst
        }else{
            firstName = usrName
        }
        
        
        let _ = ClientEditDetails(firstName: firstName, lastName: lastName, phoneNumber: cell.labelPhoneNumber.text, countryCode: "+1", address: cell.labelAddress.text, email: cell.labelEmailId.text, pinCode: cell.textFieldZipCode.text, state: cell.btnState.titleLabel?.text, city: cell.textFieldCity.text)
        let checkValidation = ClientEditDetails.getValidationResult()
        
        
        //        guard let emailAddrs = cell.labelEmailId.text else{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if emailAddrs == ""{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if User.isValidEmail(emailAddrs){}else{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //        }
        
        if checkValidation{
            let dictForBackEnd = createdDict
            
            print(dictForBackEnd)
            ApiDetector.getDataOfURL(ApiCollection.apiSaveEditting, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    cell.labelEmailId.enabled = false
                    cell.labelAddress.enabled = false
                    cell.labelPhoneNumber.enabled = false
                    cell.textFieldZipCode.enabled = false
                    cell.textFieldCity.enabled = false
                    cell.btnState.enabled = false
                    self.edit = true
                    self.btnEdit.setImage(UIImage(named: "ic_edit_white"), forState: .Normal)
                    self.btnEdit.setTitle("", forState: .Normal)
                    self.labelUserName.enabled = false
                    self.labelUserName.text = firstName.uppercaseFirst + " " + lastName.uppercaseFirst
                    trainerProfileVc.getTrainerProfile(false)
                    self.getPersonalDetails(false)
                    AlertView.callAlertView("", msg: "Changes successfully saved.", btnMsg: "OK", vc: self)
                }, method: .PostWithImage, viewControl: self, pic: imageUser.image, placeHolderImageName: "profilePic", headers: [:], showLoader: true, loaderColor: Colorss.DarkRed.toHex())
        }else{
            
        }
        
        
    }
    
    @IBAction func btnActionEditImage(sender: UIButton) {
        if edit{
            
        }else{
            let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose you action", buttons: ["Camera" , "Photo Library"], success: { [weak self]
                (state) -> () in
                self?.callFusumaImagePicker(state)
                })
            presentViewController(alertcontroller, animated: true, completion: nil)
        }
    }
    
}


extension String {
    
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatchesInString(
            self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.componentsSeparatedByString(stop)
    }
}


extension ClientsInfoViewController{
    
    func getPersonalDetails(showLoader: Bool){
        var url = ""
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            url = ApiCollection.apiClientProfile
        }else{
            url = ApiCollection.apiTrainerProfile
        }
        let dictForBackEnd = API.ApiCreateDictionary.BroadCastListing().formatParameters()
        ApiDetector.getDataOfURL(url, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                self?.boolBlockApi = true
                if isClient{
                    guard let data = data as? ClientPersonalInfo else {return}
                    self?.labelUserName.text = (data.firstName?.uppercaseFirst ?? "") + " " + (data.lastName?.uppercaseFirst ?? "")
                    let singletonData = UserDataSingleton.sharedInstance.loggedInUser
                    singletonData?.userImage?.userOriginalImage = data.userImage?.userOriginalImage
                    singletonData?.userImage?.userThumbnailImage = data.userImage?.userThumbnailImage
                    guard let firstName = data.firstName?.uppercaseFirst , last = data.lastName?.uppercaseFirst else {return}
                    singletonData?.name = firstName + " " + last
                    UserDataSingleton.sharedInstance.loggedInUser = singletonData
                    
                    print(UserDataSingleton.sharedInstance.loggedInUser?.name)
                    print(UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage)
                    
                    let imgUrl = data.userImage?.userOriginalImage
                    let imageUrl = NSURL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
                    self?.imageUser.yy_setImageWithURL(imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                }else{
                    guard let data = data as? TrainerProfile else {return}
                    self?.labelUserName.text = (data.firstName?.uppercaseFirst ?? "") + " " + (data.lastName?.uppercaseFirst ?? "")
                    let singletonData = UserDataSingleton.sharedInstance.loggedInUser
                    singletonData?.userImage?.userOriginalImage = data.userImage?.userOriginalImage
                    singletonData?.userImage?.userThumbnailImage = data.userImage?.userThumbnailImage
                    guard let firstName = data.firstName?.uppercaseFirst , last = data.lastName?.uppercaseFirst else {return}
                    singletonData?.name = firstName + " " + last
                    UserDataSingleton.sharedInstance.loggedInUser = singletonData
                    
                    print(UserDataSingleton.sharedInstance.loggedInUser?.name)
                    print(UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage)
                    
                    let imgUrl = data.userImage?.userOriginalImage
                    let imageUrl = NSURL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
                    self?.imageUser.yy_setImageWithURL(imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("ConfigureLeftDrawer", object: nil)
                
            }, method: .POST, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoader, loaderColor: Colorss.DarkRed.toHex())
    }
}