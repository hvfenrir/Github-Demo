//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//
import AFNetworking
import UIKit
import MBProgressHUD

class RepoResultsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var repos:[GithubRepo]!
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // add search bar to navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        doSearch()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let repos = repos{
            return repos.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("GithubViewCell", forIndexPath: indexPath) as! GithubViewCell
        let repo = repos[indexPath.row]
        let url = NSURL(string: repo.ownerAvatarURL!)
        cell.nameLabel.text = repo.name
        cell.ownerLabel.text = repo.ownerHandle
        cell.starsLabel.text = "\(repo.stars!)"
        cell.forksLabel.text = "\(repo.forks!)"
        cell.avatarImageView.setImageWithURL(url!)
        return cell
    }
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        GithubRepo.fetchRepos(searchSettings, successCallback: { (repos) -> Void in
            for repo in repos {
                print(repo)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.repos = repos
            self.tableView.reloadData()
        }, error: { (error) -> Void in
            print(error)
        })
    }
}

extension RepoResultsViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}