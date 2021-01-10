//
//  HomeController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/8/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ProgressHUD

class HomeController: UIViewController {
    // MARK:- Propreties
    
    private var user:User?
    private var viewModels = [CardViewModel]() {
        didSet{configureCard()}
        
    }
    private let topStack = HomeNavigationStackView()
    private let bottomStack=BottonControllersStackView()
    private let deckView:UIView={
        let view = UIView()
        view.layer.cornerRadius=5
        return view
    }()
    
    private var topCardView:CardView?
    private var cardViews = [CardView]()
    
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        AlertView.showLoader(withMessage: "Loading...")
        configureCard()
        fetchCurrentUserAndCards()
        checkIfUserIsLoggedIn()
        
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    
    // MARK:- API
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
            
        }else{
            
            print("User is logged")
            
        }
    }
    
    func logout()  {
        do{
            try Auth.auth().signOut()
            presentLoginController()
            
        } catch{
            print("Failed to logout")
        }
    }
    
    func fetchUsers(forCurrentUser user : User)  {
        Service.fetchUsers(forCurrentUser: user) { users in
            
            self.viewModels = users.map({ CardViewModel(user: $0)})
            
            //the line above is equal
            //            users.forEach { (user) in
            //                let viewModel = CardViewModel(user: user)
            //                self.viewModels.append(viewModel)
            //
            //            }
            
            
            ProgressHUD.dismiss()
            
        }
    }
    func fetchCurrentUserAndCards()  {
        guard let uID = Auth.auth().currentUser?.uid else{
            return}
        Service.fetchUser(withUid: uID) { user in
            self.user = user
            self.fetchUsers(forCurrentUser: user)
            
        }
    }
    
    func saveSwipesAndCheckMatch(forUser user:User,didLiked : Bool)  {
        Service.saveSwipes(forUser: user, isLike: didLiked) { (error) in
            self.topCardView = self.cardViews.last
            guard didLiked == true else{return}
            
            Service.checkIfMatchExist(forUser: user) { (didMatch) in
                self.presentMatchView(forUser: user)
                guard let currentUser = self.user else {return}
                Service.uploadMatch(currentUser: currentUser, matchedUser: user)
                
                
            }
        }
    }
    
    // MARK:- Helpers
    func configureCard() {
        viewModels.forEach { (viewModel) in
            let card = CardView(viewModel: viewModel)
            card.delegate = self
            //cardViews.append(card)
            deckView.addSubview(card)
            card.fillSuperview()
        }
        cardViews = deckView.subviews.map({$0 as! CardView})
        topCardView = cardViews.last
    }
    
    func configureUI()  {
        topStack.delegate=self
        bottomStack.delegate = self
        view.backgroundColor = .white
        let stack=UIStackView(arrangedSubviews: [topStack,deckView,bottomStack])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.safeAreaLayoutGuide.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement=true
        stack.bringSubviewToFront(deckView)
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        
    }
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    func performSwipAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            guard !self.cardViews.isEmpty else {return}
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
            
        }
        
    }
    func presentMatchView(forUser user : User) {
        guard let currentUser = self.user else {return}
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    func showChatController(forUser user :User)  {
        let chatController = ChatController(user: user)
        let nav = UINavigationController(rootViewController: chatController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}





//MARK: -HomeNavigationStackDelegate
extension HomeController :HomeNavigationStackDelegate{
    func showMessages() {
        guard let user = self.user else {return}
        let Controller = MessagesController(user: user)
        let nav = UINavigationController(rootViewController: Controller)
        
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
        
    }
    
    func showSettings() {
        
        
        guard let user = self.user else {
            
            return
        }
        let controller = SettingsController(user: user)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
        
        
        
    }
    
    
}
//MARK: -SettingControllerDelegate
extension HomeController : SettingControllerDelegate{
    func settingsControllerWantsToLogout(_ controller: SettingsController) {
        controller.dismiss(animated: true, completion: nil)
        logout()
    }
    
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
    }
    
    
    
}

//MARK: -cardViewDelegate

extension HomeController : cardViewDelegate{
    func cardView(_ view: CardView, didLikeUser: Bool) {
        view.removeFromSuperview()
        cardViews.removeAll(where: {view == $0})
        guard let user = topCardView?.viewModel.user else{return}
        //Service.saveSwipes(forUser: user, isLike: didLikeUser, completion: nil)
        self.saveSwipesAndCheckMatch(forUser: user, didLiked: didLikeUser)
        self.topCardView = cardViews.last
    }
    
    func cardView(_ view: CardView, wantsToShowUserProfile user: User) {
        let controller = ProfileController(user: user)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
    
    
    
}

//MARK:- BottonControllersStackViewDelegate
extension HomeController : BottonControllersStackViewDelegate{
    func like() {
        
        guard let card = topCardView else {return}
        performSwipAnimation(shouldLike: true)
        //Service.saveSwipes(forUser: card.viewModel.user, isLike: true, completion: nil)
        self.saveSwipesAndCheckMatch(forUser: card.viewModel.user, didLiked: true)
        
        
    }
    
    func disLike() {
        guard let card = topCardView else {return}
        performSwipAnimation(shouldLike: false)
        Service.saveSwipes(forUser: card.viewModel.user, isLike: false, completion: nil)
        
        
    }
    
    func refresh() {
        AlertView.showLoader(withMessage: "Loading...")
        guard let user = self.user else { return }
        Service.fetchUsers(forCurrentUser: user) { (users) in
            self.viewModels = users.map({CardViewModel(user: $0)})
            ProgressHUD.dismiss()
        }
        
        
    }
    
    
}
//MARK: -ProfileControllerDelegate
extension HomeController : ProfileControllerDelegate{
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipAnimation(shouldLike: true)
            //Service.saveSwipes(forUser: user, isLike: true)
            self.saveSwipesAndCheckMatch(forUser: user, didLiked: true)
            
            
        }
        
        
        
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        controller.dismiss(animated: true) {
            self.performSwipAnimation(shouldLike: false)
            Service.saveSwipes(forUser: user, isLike: false, completion: nil)
            
            
            
        }
    }
}
//MARK: -AuthDelegate
extension HomeController : AuthDelegate{
    func authComplete() {
        dismiss(animated: true, completion: nil)
        fetchCurrentUserAndCards()
    }
    
    
}
//MARK: -MatchViewDelegate

extension HomeController : MatchViewDelegate {
    func matchView(view: MatchView, wantsToSendMessageTo user: User) {
        print("Start coversation with \(user.name)")
        showChatController(forUser: user)
        
        
        
        
    }
    
    
    
}





