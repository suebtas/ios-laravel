//
//  BooksTableViewController.swift
//  iOS Laravel Navigator
//
//  Created by Suebtas on 10/23/2559 BE.
//  Copyright © 2559 Suebtas. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController {
    
    var books: [Book] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var laravelClient: LaravelClient!

    
    struct Storyboard {
        static let bookCell = "BookCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        laravelClient = LaravelClient(clientID: "", clientSecret: "")
        self.fetchBooks()
    }
    
    @IBAction func fetchBooks()
    {
        
        laravelClient.fetchBookFor(completion: { (result) in
            switch result {
            case .success(let books):
                self.books = books
                self.refreshControl?.endRefreshing()
            case .failure(let error):
                // CHALLENGE: display an alert view to show error. error.localizedDescription
                print(error)
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - Table view data source
extension BooksTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.bookCell, for: indexPath) //as! BookTableViewCell
        
        let book = books[indexPath.row]
        
        cell.textLabel?.text = book.title
        //cell.book = book
        
        return cell
    }
}

