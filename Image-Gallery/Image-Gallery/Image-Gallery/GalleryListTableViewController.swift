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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if traitCollection.verticalSizeClass == .compact {
            if splitViewController?.preferredDisplayMode != .primaryOverlay {
                splitViewController?.preferredDisplayMode = .primaryOverlay
            }
        }
        
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func addRows(_ sender: UIBarButtonItem) {
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(row: galleries[0].count, section: 0)], with: .bottom)
            galleries[0].append(Gallery(name: "Untitled Gallery " + "\(galleries[0].count+1)"))
        }, completion: nil)
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Gallery Cell", for: indexPath)
        if let gvc = cell as? GalleryTableViewCell {
                gvc.textField.text = galleries[indexPath.section][indexPath.row].galleryName
                gvc.textField.isEnabled = false
                gvc.textField.delegate = self
            let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(handleTextFieldTap(sender:)))
            tapGuesture.numberOfTapsRequired = 2
            gvc.addGestureRecognizer(tapGuesture)
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
           
            if indexPath.section == 0 {
                let gallery = galleries[0].remove(at: indexPath.row)
                galleries[1].append(gallery)
                tableView.moveRow(at: indexPath, to: IndexPath(row: galleries[1].count - 1, section: 1))
                tableView.reloadData()
                
            } else {
                galleries[1].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let ca = UIContextualAction(style: .normal, title: "Restore", handler: {_,_,_ in
                tableView.performBatchUpdates({ [weak self] in
                    if let gallery = self?.galleries[1].remove(at: indexPath.row) {
                        self?.galleries[0].append(gallery)
                        tableView.moveRow(at: indexPath, to: IndexPath(row: (self?.galleries[0].count)! - 1, section: 0))
                        tableView.reloadData()
                    }
                    }, completion:  {
                        (_) in
                })
            })
            ca.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            let sac = UISwipeActionsConfiguration(actions: [ca])
            sac.performsFirstActionWithFullSwipe = true
            return sac
        } else {
            return nil
        }
    }
    
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "To CollectionView", sender: indexPath)
        }
    }
    
    // MARK: - Navigation
    private var splitViewControllerDetail : UINavigationController? {
        return splitViewController?.viewControllers.last as? UINavigationController
    }
    
    private var lastSequedToCollectionViewController : GalleryCollectionViewController?
    private var lastIndexPath : IndexPath?
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "To CollectionView" {
            if let indexPath = sender as? IndexPath {
                if let destination = segue.destination.setTitleAndReturnGalleryCollectionView(with: galleries[indexPath.section][indexPath.row].galleryName) as? GalleryCollectionViewController {
                    lastSequedToCollectionViewController = destination
                    destination.gallery = galleries[indexPath.section][indexPath.row]
                    destination.reloadImages()
                } 
            }
        }
    }
    
    
    private var currentDoubleTappedCell : IndexPath?
    
    @objc private func handleTextFieldTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let gvc = sender.view as? GalleryTableViewCell {
                gvc.textField.isEnabled = true
                gvc.textField.becomeFirstResponder()
                currentDoubleTappedCell = tableView.indexPath(for: gvc)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //MARK: To handle blanks
        func setTitle(sender cdc: IndexPath) {
            splitViewControllerDetail?.navigationBar.topItem?.title = galleries[cdc.section][cdc.row].galleryName
        }
        
        if let cdc = currentDoubleTappedCell {
            if let txt = textField.text, txt.count > 0 {
                galleries[cdc.section][cdc.row].galleryName = txt
                setTitle(sender: cdc)
            } else {
                textField.text = galleries[cdc.section][cdc.row].galleryName
                setTitle(sender: cdc)
            }
        }
        textField.isEnabled = false
        currentDoubleTappedCell = nil
    }
    
}
extension UIViewController {
    
    func setTitleAndReturnGalleryCollectionView(with title: String) -> UIViewController? {
        if let navcon  = self as? UINavigationController {
            navcon.navigationBar.topItem?.title = title
            return navcon.topViewController
        } else {
            return self
        }
    }
}

