//
//  HeroesListTableViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class HeroesListTableViewController: UITableViewController {
    
    var isDataLoading =  false
    var offset = 0
    let service = Services()
    var heroes = [Result]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView .register(UINib(nibName: "HeroCell", bundle: nil), forCellReuseIdentifier: "HeroCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let spinner = UIActivityIndicatorView(style: .gray)
        tableView.tableFooterView = spinner
        spinner.startAnimating()
        
        loadHeroes()
        
    }
    
    func loadHeroes () {
        
        isDataLoading = true
        service.request(offset: 20 * offset) { models in
    
        
        
        let indexPaths = (self.heroes.count..<(self.heroes.count + models.data.results.count)).map { item in
            return IndexPath(item: item, section: 0)
        }
            
            self.heroes.append(contentsOf: models.data.results)
         self.tableView.insertRows(at: indexPaths, with: .none)
        self.offset += 1
            self.isDataLoading = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heroes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = heroes[indexPath.row].name
//        let url = URL(string: (heroes[indexPath.row].thumbnail.path) + "." + (heroes[indexPath.row].thumbnail.pathExtension))
//        
//        cell.imageView?.image = UIImage(named: "loading")
//        cell.imageView?.setURL(url: url!)
        

        return cell
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isDataLoading = true
                
                loadHeroes()
            }
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
