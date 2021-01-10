//
//  MessagesController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/2/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"
class MessagesController : UITableViewController {
    //MARK:- Proprities
    let user : User
    let header:MatchHeader = MatchHeader()
    var conversations = [Conversation]()
    var conversationDic = [String:Conversation]()
    let searchController = UISearchController(searchResultsController: nil)
    var matches = [Match]()
    var fillterdmatches=[Match]()
    private var isInSearchMood : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    //MARK:- Lifecycel

    init(user:User){
        self.user = user
        super.init(style: .plain)
    }
    override func viewDidLoad() {
        configTableView()
        configNavigationBar()
        configSearchcontroller()
        fetchMatches()
        header.delegate = self
        fetchConversations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- API
    
    func fetchMatches() {
        Service.fetchMatches { (matches) in
            
           // self.matches = matches
            var newMatches = [Match]()
            for match in matches{
                Service.fetchUser(withUid: match.uid!) { (user) in
                  //  print("+++++name is \(user.name) \(String(describing: user.imageURLs.last))")
                    
                   newMatches.append(Match(user: user))
                    self.header.matches = newMatches
                    self.matches=newMatches
                   
                }
            }
            

            self.header.matches = self.isInSearchMood ? self.fillterdmatches : self.matches

        }
        
        
    }
    
    func fetchConversations()  {
        Service.fetchConversation { (conversations) in
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationDic[message.chatPartenerId] = conversation
            }
            self.conversations = Array(self.conversationDic.values)
            self.tableView.reloadData()
            
        }
    }

    
    //MARK:- Helpers
    
   func configTableView(){
    tableView.rowHeight = 88
    tableView.tableFooterView = UIView()
    tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
    header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
    tableView.tableHeaderView =  header
    
    
   }
    
    func configNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelDismiss))
        leftButton.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        let icon = UIImageView()
        icon.setDimensions(height: 28, width: 28)
        icon.image = #imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navigationItem.titleView = icon



        
    }
    func showChatController(forUser user :User)  {
        let chatController = ChatController(user: user)
        let nav = UINavigationController(rootViewController: chatController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
    func configSearchcontroller() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a match "
        definesPresentationContext = false
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .white
        }
    }
  

    
    
    //MARK:- Actions
    @objc func handelDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    

}

//MARK:- UITableViewDataSource

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
        
        return cell
    }
    
}
//MARK:- UITableViewDelegate

extension MessagesController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = conversations[indexPath.row].user

        showChatController(forUser: user)
        
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let lable = UILabel()
        
        lable.text = "Messages"
        lable.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        lable.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(lable)
        lable.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft:16)
        return view
    }
    
    
}

extension MessagesController : MatchHeaderDelegate{
    func matchHaeder(_ header: MatchHeader, wantsToStartChatWith uid: String) {
        
        Service.fetchUser(withUid: uid) { (user) in
            self.showChatController(forUser: user)
        }
    }
    
    
}

//MARK:- UISearchResultsUpdating

extension MessagesController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return  }
        print(searchText)
        fillterdmatches = matches.filter({ (match) -> Bool in
            return (match.name?.lowercased().contains(searchText) ?? false)
        })
        
        header.matches = isInSearchMood ? fillterdmatches : matches
        
        
    }
    
    
    
}


