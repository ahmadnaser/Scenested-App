////
////  ProfileViewController.swift
////  poststed-experiment
////
////  Created by Xie kesong on 4/10/16.
////  Copyright © 2016 ___poststed___. All rights reserved.
////
//
//import UIKit
//
//class ProfileViewController: EditableProfileViewController {
//    
//    @IBOutlet weak var profileCover: UIImageView!
//    
//    @IBOutlet weak var profileCoverHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var featureSlideHeightConstraint: NSLayoutConstraint!
//    
//    @IBOutlet weak var profileAvator: UIImageView!{
//        didSet{
//            profileAvator.becomeCircleAvator()
//        }
//    }
//    
//    @IBOutlet weak var profileFullName: UILabel!
//    
//    
//    @IBOutlet weak var profileButtonBelowCover: UIButton!{
//        didSet{
//            profileButtonBelowCover?.becomeEditProfileButton()
//        }
//    }
//    
//    
//    @IBOutlet weak var featuresCollectionView: UICollectionView!
//    
//    @IBOutlet weak var globalView: UITableView!
//    
//    @IBOutlet weak var tableHeaderView: UIView!
//    
//    @IBOutlet weak var profileBioTextView: UITextView!
//    
//    @IBOutlet weak var navigationBar: UINavigationItem!
//    
//    
//    @IBOutlet weak var profileButtonBelowCoverWidthConstaint: NSLayoutConstraint!
//    
//    @IBAction func cancelEditProfile(unwindSegue: UIStoryboardSegue){
//        //no further action required
//    }
//    
//    @IBAction func cancelAddFeature(unwindSegue: UIStoryboardSegue){
//    }
//    
//    @IBAction func cancelComposePost(unwindSegue: UIStoryboardSegue){
//    }
//    
//    
//    
//    @IBAction func composePost(sender: UIBarButtonItem) {
//        if let editPostNVC =  storyboard?.instantiateViewControllerWithIdentifier(StoryboardIden.EditPostNavigationViewControllerIden) as? EditPostNavigationViewController{
//            self.presentViewController(editPostNVC, animated: true, completion: nil)
//        }
//    }
//    
//    @IBAction func profileBelowBtnTriggered(sender: UIButton) {
//        //present edit profile
//        if let editProfileNVC = storyboard?.instantiateViewControllerWithIdentifier("EditProfileNaviIden") as? EditProfileNavigationController{
//            if let editProfileVC = editProfileNVC.viewControllers.first as? EditProfileViewController{
//                editProfileVC.profileCoverImage = self.profileCover.image
//                editProfileVC.profileAvatorImage = self.profileAvator.image
//                editProfileVC.fullNameText = self.profileFullName.text
//                editProfileVC.bioText = self.profileBioTextView.text
//                self.presentViewController(editProfileNVC, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    
//    @IBAction func addfeatureBoxTapped(sender: UITapGestureRecognizer) {
//        let alert = UIAlertController(title: "Add Cover for New Feature", message: nil, preferredStyle: .ActionSheet)
//        
//        let chooseExistingAction = UIAlertAction(title: "Choose from Library", style: .Default, handler: { (action) -> Void in
//            self.chooseFromLibarary()
//            if getLoggedInUserFeatureCount() > 0{
//                self.hideAddFeatureBox()
//            }
//        })
//        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
//            (action) -> Void in
//            self.takePhoto()
//            if getLoggedInUserFeatureCount() > 0{
//                self.hideAddFeatureBox()
//            }
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        alert.addAction(takePhotoAction)
//        alert.addAction(chooseExistingAction)
//        alert.addAction(cancelAction)
//        imagePickerUploadPhotoFor = UploadPhotoFor.featureCover
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    
//    private var profileCoverHeight: CGFloat = 0
//    private var headerHeightOffset: CGFloat = 0 // make the cover's height little bit larger than the original screen height
//    private var profileCoverOriginalScreenHeight: CGFloat = 0
//    
//    private var featureImageSize: CGSize = CGSizeZero //the size of the individual feature UIImageView
//    
//    private let sectionHeaderHeight:CGFloat = 46
//    
//    private let initialContentOffsetTop: CGFloat = 64.0
//    
//    
//    /* define the style constant for the feature slide  */
//    private struct featureSlideConstant{
//        struct sectionEdgeInset{
//            static let top:CGFloat = 0
//            static let left:CGFloat = 12
//            static let bottom:CGFloat = 0
//            static let right:CGFloat = 12
//        }
//        
//        static let contentInsetWithAddfeatureBox: UIEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
//        
//        //the space between each item
//        static let lineSpace: CGFloat = 8
//        static let maxVisiblefeatureCount: CGFloat = 2.2
//        //the max number of feature that is allowed to display at the screen
//        static let featureImageAspectRatio:CGFloat = 6 / 7
//        static let precicitionOffset: CGFloat = 1 //prevent the height of the collectionView from less than the total of the cell height and inset during the calculation
//        static let featureCellReuseIdentifier: String = "featureCell"
//    }
//    
//    private var addFeatureBoxOpen:Bool = false
//    
//    private var isFeatureActionSheetActive = false
//    
//    private var minTableHeaderHeight:CGFloat = 0
//    
//    
//    //true if the current profile belongs to the logged in user
//    private var isLoggedInUserProfile = false
//    
//    var profileUser: User?{
//        didSet{
//            //isLoggedInUserProfile = (profileUser!.id == getLoggedInUser()!.id)
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadUserData()
//        featuresCollectionView.delegate = self
//        featuresCollectionView.dataSource = self
//        featuresCollectionView.alwaysBounceHorizontal = true
//        
//        //        globalView.delegate = self
//        //        globalView.dataSource = self
//        globalView.estimatedRowHeight = globalView.rowHeight
//        globalView.rowHeight = UITableViewAutomaticDimension
//        
//        //see whether there is a need for pushing profileViewController or not
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.featureAdded(_:)), name: NotificationLocalizedString.AddFeatureSucceedNotification, object: nil)
//        
//        self.navigationItem.rightBarButtonItem!.becomeStyleBarButtonItem()
//        
//        
//        
//        
//        
//        
//        addTapGestureForAvator()
//        addTapGestureForCover()
//    }
//    
//    //set up if isLoggedInUserProfile is true
//    func selfProfileSetUp(){
//        if isLoggedInUserProfile{
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileViewController.featureAdded(_:)), name: NotificationLocalizedString.AddFeatureSucceedNotification, object: nil)
//            
//        }
//    }
//    //additional setup
//    override func viewDidLayoutSubviews() {
//        // tableHeaderView.frame.size.height = tableHeaderView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//        //make sure the header view contans the exact necessary height given it's dynamic content
//        setupfeatureSlideCollectionView()
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //stretchy header set up
//        self.globalScrollView = globalView
//        self.coverImageView = profileCover
//        self.coverHeight = profileCover.bounds.size.height
//        self.defaultInitialContentOffsetTop = initialContentOffsetTop
//        self.stretchWhenContentOffsetLessThanZero = true
//        
//        
//        minTableHeaderHeight = (tableHeaderView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)).height
//        tableHeaderView.frame.size.height = minTableHeaderHeight//the minimum height for the tableheader view
//        
//        if getLoggedInUserFeatureCount() > 0{
//            addFeatureBoxOpen = false
//            featuresCollectionView.contentInset.left = -featureImageSize.width
//        }else{
//            addFeatureBoxOpen = true
//            featuresCollectionView.contentInset.left = featureSlideConstant.contentInsetWithAddfeatureBox.left
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let featureVC = segue.destinationViewController as? FeatureViewController{
//            if let selectedfeatureIndexPath = featuresCollectionView.indexPathsForSelectedItems()?.first{
//                let selectedCell = featuresCollectionView.cellForItemAtIndexPath(selectedfeatureIndexPath) as! FeatureCollectionViewCell
//                featureVC.feature = selectedCell.feature
//            }
//        }
//    }
//    
//    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.isKindOfClass(UITableView){
//            //scrolling the global table View
//            super.scrollViewDidScroll(scrollView)
//            
//        }else if scrollView.isKindOfClass(UICollectionView){
//            //scrolling the horizontal feature slider
//        }
//    }
//    
//    func loadUserData(){
//        if let profileUser = profileUser{
//            dispatch_async(dispatch_get_main_queue(), {
//                self.navigationBar.title = profileUser.username?.uppercaseString
//                self.profileFullName.text = profileUser.fullname
//                self.profileBioTextView.setStyleText(profileUser.bio!)
//            })
//            
//            if let avator = profileUser.avator{
//                self.profileAvator.loadImageWithUrl(avator.url, imageUrlHash: avator.hash, cacheType: CacheType.CacheForProfileAvator)
//            }
//            
//            if let cover = profileUser.cover{
//                self.profileCover.loadImageWithUrl(cover.url, imageUrlHash: cover.hash, cacheType: CacheType.CacheForProfileCover)
//            }
//        }
//    }
//    
//    
//    func addTapGestureForAvator(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapAvator))
//        profileAvator.addGestureRecognizer(tap)
//    }
//    
//    func addTapGestureForCover(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapCover))
//        profileCover.addGestureRecognizer(tap)
//    }
//    
//    
//    
//    
//    func setupfeatureSlideCollectionView(){
//        //the size for the feature image
//        featureImageSize.width = (UIScreen.mainScreen().bounds.size.width - featureSlideConstant.sectionEdgeInset.left - 2*featureSlideConstant.lineSpace) / featureSlideConstant.maxVisiblefeatureCount
//        featureImageSize.height = featureImageSize.width / featureSlideConstant.featureImageAspectRatio
//        //the height for the featureCollectionView
//        
//        
//        featureSlideHeightConstraint.constant = featureImageSize.height + featureSlideConstant.sectionEdgeInset.top + featureSlideConstant.sectionEdgeInset.bottom + featureSlideConstant.precicitionOffset
//        
//        
//        
//        //        if profileFeatures.count > 0{
//        //            featuresCollectionView.contentInset.left = -featureImageSize.width
//        //        }else{
//        //            featuresCollectionView.contentInset.left = featureSlideConstant.contentInsetWithAddfeatureBox.left
//        //        }
//    }
//    
//    
//    
//    func hideAddFeatureBox(){
//        addFeatureBoxOpen = false
//        dispatch_async(dispatch_get_main_queue(), {
//            UIView.animateWithDuration(0.2, animations: {
//                self.featuresCollectionView.contentInset.left = -self.featureImageSize.width
//            })
//        })
//        
//    }
//    
//    func openAddFeatureBox(){
//        addFeatureBoxOpen = true
//        dispatch_async(dispatch_get_main_queue(), {
//            UIView.animateWithDuration(0.2, animations: {
//                self.featuresCollectionView.contentInset.left = featureSlideConstant.contentInsetWithAddfeatureBox.left
//                }, completion: {
//                    finished in
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if finished{
//                            UIView.animateWithDuration(0.2, animations: {
//                                self.featuresCollectionView.contentOffset.x = -14
//                            })
//                        }
//                    })
//            })
//        })
//    }
//    
//    
//    func featureLongPressed(gesture: UIGestureRecognizer){
//        if !isFeatureActionSheetActive{
//            let actionSheet = UIAlertController(title: "\n\n\n\n\n", message: "", preferredStyle: .ActionSheet)
//            let featureCollectionViewCell = (gesture.view as! FeatureCollectionViewCell)
//            let thumbImage = featureCollectionViewCell.featureImage.image
//            
//            let margin: CGFloat = 10.0
//            let thumbImageViewWidth: CGFloat = 100.0
//            
//            //construct the thumbnail on the action sheet title
//            let thumbImageView = UIImageView(frame: CGRectMake(margin, margin, thumbImageViewWidth, thumbImageViewWidth))
//            thumbImageView.image = thumbImage
//            thumbImageView.clipsToBounds = true
//            thumbImageView.contentMode = .ScaleAspectFill
//            thumbImageView.layer.cornerRadius = 8.0
//            actionSheet.view.addSubview(thumbImageView)
//            
//            //construct the label on the action sheet title
//            let nameLabel = UILabel(frame: CGRectMake(thumbImageViewWidth + 2 * margin, margin, actionSheet.view.bounds.size.width - 5 * margin - thumbImageViewWidth, 30.0))
//            nameLabel.text = featureCollectionViewCell.featureName.text
//            nameLabel.textColor = StyleSchemeConstant.themeMainTextColor
//            nameLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightSemibold)
//            actionSheet.view.addSubview(nameLabel)
//            
//            let addpostAction = UIAlertAction(title: "Add Post", style: .Default, handler: {
//                alertAction in
//                if let editPostNVC =  self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIden.EditPostNavigationViewControllerIden) as? EditPostNavigationViewController{
//                    if let editPostVC = editPostNVC.viewControllers.first as? EditPostViewController{
//                        editPostVC.feature = featureCollectionViewCell.feature
//                        self.presentViewController(editPostNVC, animated: true, completion: nil)
//                    }
//                    self.isFeatureActionSheetActive = false
//                    
//                }
//            })
//            let deletefeatureAction = UIAlertAction(title: "Delete Feature", style: .Destructive, handler: {
//                alertAction in
//                let alert = UIAlertController(title: "Delete Feature", message: "All the posts inside " + featureCollectionViewCell.featureName.text! + " will be removed as well", preferredStyle: .Alert)
//                let confirmAction = UIAlertAction(title: "Delete", style: .Default, handler: {
//                    alertAction in
//                    getLoggedInUser()?.deleteFeature(featureCollectionViewCell.feature!, completionHandler: {
//                        succeed in
//                        if succeed{
//                            if let indexPath = self.featuresCollectionView.indexPathForCell(featureCollectionViewCell){
//                                getLoggedInUser()?.features?.removeAtIndex(indexPath.row)
//                                self.featuresCollectionView.reloadData()
//                                if getLoggedInUserFeatureCount() < 1{
//                                    self.openAddFeatureBox()
//                                }
//                            }
//                        }
//                    })
//                })
//                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//                alert.addAction(confirmAction)
//                alert.addAction(cancelAction)
//                self.presentViewController(alert, animated: true, completion: nil)
//                self.isFeatureActionSheetActive = false
//            })
//            let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: {
//                _ -> Void in
//                self.isFeatureActionSheetActive = false
//            })
//            actionSheet.addAction(addpostAction)
//            actionSheet.addAction(deletefeatureAction)
//            actionSheet.addAction(doneAction)
//            self.presentViewController(actionSheet, animated: true, completion: nil)
//            isFeatureActionSheetActive = true
//        }
//    }
//    
//    func featureAdded(notification: NSNotification){
//        //        if let feature = notification.userInfo!["feature"] as? Feature{
//        self.featuresCollectionView.reloadData()
//        self.hideAddFeatureBox()
//        self.dismissViewControllerAnimated(true, completion: nil)
//        // }
//    }
//    
//    
//}
//
//
//
//// MARK:: built in protocol
//
//// MARK:: horizontal feature slider, Extension for UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout protocol
//extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AddfeatureBoxIden", forIndexPath: indexPath)
//        headerView.frame.size.height = featureImageSize.height
//        
//        headerView.layer.cornerRadius = StyleSchemeConstant.horizontalSlider.horizontalSliderCornerRadius
//        return headerView
//    }
//    
//    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView.isKindOfClass(UICollectionView){
//            if addFeatureBoxOpen{
//                if scrollView.contentOffset.x > 0{
//                    hideAddFeatureBox()
//                }
//            }
//            else{
//                if scrollView.contentOffset.x < 70{
//                    openAddFeatureBox()
//                    
//                }
//            }
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return getLoggedInUserFeatureCount()
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let featureCell = collectionView.dequeueReusableCellWithReuseIdentifier(featureSlideConstant.featureCellReuseIdentifier, forIndexPath: indexPath) as! FeatureCollectionViewCell
//        featureCell.layer.cornerRadius = StyleSchemeConstant.horizontalSlider.horizontalSliderCornerRadius
//        
//        featureCell.feature = getLoggedInUser()?.features![indexPath.row]
//        let longPressGuesture = UILongPressGestureRecognizer(target: self, action: #selector(ProfileViewController.featureLongPressed))
//        featureCell.addGestureRecognizer(longPressGuesture)
//        return featureCell
//    }
//    
//    
//    
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: featureSlideConstant.sectionEdgeInset.top, left: featureSlideConstant.sectionEdgeInset.left, bottom: featureSlideConstant.sectionEdgeInset.bottom, right: featureSlideConstant.sectionEdgeInset.right)
//        
//        
//        
//    }
//    
//    
//    // **if is set to horizontal scrolling, the line spacing is the space between each column**
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return featureSlideConstant.lineSpace
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return featureImageSize
//    }
//    
//    
//    //only the height width is used for horizontal slider
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return featureImageSize
//    }
//    
//}
//
//
//
//// MARK:: Post Rows, Extension for UITableViewDelegate and UITableViewDataSource protocol
////extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
////    //defines how many weeks the profile user has
////    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
////        return 1
////    }
////
////    //each section is a collection of the same week
////    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////
////
////
////        return getLoggedInUser()?.features
////    }
////
////    //define the data source for a specific week
////    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
////        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
//////        cell.postPictureUrl = profileposts[indexPath.row].imageUrl
//////        cell.featureName = profileposts[indexPath.row].featureName
//////        cell.descriptionText = profileposts[indexPath.row].postText
//////        cell.postUser = profileposts[indexPath.row].postUser
//////        cell.postTimeText = profileposts[indexPath.row].postTime
////        return cell
////    }
////
////
////    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        return 0
////    }
////}
//
////extension ProfileViewController: UIViewControllerTransitioningDelegate{
////    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        closeUpTransition.selectedItemInfo = selectedThumbnailItemInfo
////        return closeUpTransition
////    }
////
////    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
////        closeUpTransition.presenting = true
////        return closeUpTransition
////    }
////}
////
//
//
//
//// MARK:: custom protocol
////extension ProfileViewController: PostCollectionViewProtocol{
////    func didTapCell(collectionView: UICollectionView, indexPath: NSIndexPath, post: Post, selectedItemInfo: CloseUpEffectSelectedItemInfo) {
//////        self.interactingCollectionView = collectionView
////        //present the postDetailViewController
////     let postDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("postDetailViewControllerIden") as! postDetailViewController
//////          let postDetailViewController = postDetailNavigationController.viewControllers[0] as! postDetailViewController
//////
////        postDetailViewController.post = post
//////        postDetailViewController.transitioningDelegate = self
////        self.selectedThumbnailpost = post
////        self.selectedThumbnailItemInfo = selectedItemInfo
////        self.presentViewController(postDetailViewController, animated: true, completion: nil)
////    }
////}
//
//
//
//
////
////extension ProfileViewController: CloseUpMainProtocol{
////    func closeUpTransitionGlobalScrollView() -> UIScrollView {
////        return globalView
////    }
////}
//
//
//
