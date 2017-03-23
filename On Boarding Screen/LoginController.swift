//
//  ViewController.swift
//  On Boarding Screen
//
//  Created by Matt Houston on 9/18/16.
//  Copyright © 2016 On Boarding Screen. All rights reserved.
//

import UIKit


//class to break retain cycle. specify weak on delegate variable
protocol LoginControllerDelegate: class {
    
    func finishLoggingIn()
}

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoginControllerDelegate {
    
    let cellId = "cellId"
    
    let pages: [Page] = {
        
        let firstPage = Page(title: "Share a great listen", message: "Free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1")
        let secondPage = Page(title: "Send from your library", message: "Tap the More menu next to any book.", imageName: "page2")
        let thirdPage = Page(title: "Send from the player", message: "Tap the More menu in the upper corner.", imageName: "page3")
        
        return [firstPage, secondPage, thirdPage]
    } ()
    
    //add collectionView inside of View Controller
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0 //eliminates the gap between the cells when swiping
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type:.system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
            , for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    func skip() {
        //this goes to third page and then calls the nextPage() method which implements the functionality
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    func nextPage() {
        
        //we are on the last page
        if pageControl.currentPage == pages.count {
            return
        }
        
        //if i am on second to last page move controls off screen
        if pageControl.currentPage == pages.count - 1 {
           moveControlConstraintsOffScreen()
            
            //preferrable animation method
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded() //this is needed to animate constraints
                }, completion: nil)

        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        //you have to increment current page
        pageControl.currentPage += 1
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        //animate pageControl off screen
        self.pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -40
        nextButtonTopAnchor?.constant = -40
        
    }
    
    let loginCellId = "loginCellId"
    
    fileprivate func registerCells() {
        
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        observeKeyboardNotifications()
       
        registerCells()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
    
        //auto layout collectionView
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)[1] //the one in brackets returns the first anchor in the anchor call which is the bottom parameter.

        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first //returns first anchor to the variable
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first //returns first anchor to the variable
    
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    
    //as keyboard shows push elements up so that the keyboard isn't blocking the ui elements
    func keyboardShow() {
        print("keyboard shown")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            
            //if landscape -100 otherwise -50
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
            //when you go off screen or dismiss the keyboard bring ui elements back down
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: .UIKeyboardWillHide, object: nil)
            
            }, completion: nil)
    }
    
    func keyboardHide() {
        
        //animate views back to original state
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        })
    }
    
    
    //MARK: Collection View Delegates - Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        
        return cell
    }
    
    func finishLoggingIn() {
        print("finished logging in")
        dismiss(animated: true, completion: nil)
        
        //show home controller
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        guard let MainNavigationController = rootViewController as? MainNavigationController else {return}
        
        MainNavigationController.viewControllers = [HomeController()]
        
        //save logged in state to user defaults
        UserDefaults.standard.setIsLoggedIn(value: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    //dismiss keyboard on scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print(targetContentOffset.pointee.x)
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //if we are on the last page
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            self.pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        
        //preferrable animation method
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded() //this is needed to animate constraints
            }, completion: nil)

        
    }
    
    //Landscape mode code
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //Bool return
        //print(UIDevice.current.orientation.isLandscape)
        
        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)

        
        DispatchQueue.main.async {
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.collectionView.reloadData() //IMPORTANT!!!!! RELOADS CELLS CORRECTLY
    }
    

}
}

















