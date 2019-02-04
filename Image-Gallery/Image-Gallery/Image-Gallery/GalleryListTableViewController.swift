//
//  GalleryListTableViewController.swift
//  Image-Gallery
//
//  Created by Arnab Sen on 04/02/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class GalleryListTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    private var galleries = [[Gallery](), [Gallery]()]
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return galleries[section].count
    }

    @IBAction func addRows(_ sender: UIBarButtonItem) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(row: galleries[0].count, section: 0)], with: .bottom)
            galleries[0].append(Gallery(name: "Untitled Gallery " + "\(galleries[0].count + 1)"))
        }, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gallery Cell", for: indexPath)
        if let gvc = cell as? GalleryTableViewCell {
            gvc.textField.text = galleries[indexPath.section][indexPath.row].galleryName
            gvc.textField.delegate = self
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "" : "RECENTLY DELETED"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//    }
    
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
    
    private func restoreCells (at indexPath : IndexPath) {
        
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let foundIndexWithCollidingNames = galleries[0].indices.filter { galleries[0][$0].galleryName == textField.text}
        if foundIndexWithCollidingNames.count > 0 {
            let alert = UIAlertController(title: "Error", message: "Gallery Already Exists.\n Rename Gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.isEnabled = false
    }
    

}
