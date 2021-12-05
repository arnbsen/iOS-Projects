//
//  ThemeChooserViewController.swift
//  Animated-Set-Concentration
//
//  Created by Arnab Sen on 17/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.currentSelection == 3 {
                // If theme is not set please collapse the primary view controller (Master in case) on the top of secondary (Detail in this case)
                // True means please collapse primary on top of secondary
                return true
            }
        }
        return false
    }
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = splitViewControllerDetail, cvc.currentSelection != 3{
            if let selection = (sender as? UIButton)?.titleLabel?.text {
                cvc.currentSelection = chooseTheme(having: selection)
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let selection = (sender as? UIButton)?.titleLabel?.text {
                cvc.currentSelection = chooseTheme(having: selection)
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    
    
    
    private var splitViewControllerDetail : ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController : ConcentrationViewController?
    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier, identifier == "Choose Theme" {
            if let cvc = segue.destination as? ConcentrationViewController {
                if let selection = (sender as? UIButton)?.titleLabel?.text {
                    cvc.currentSelection = chooseTheme(having: selection)
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
    
    private func chooseTheme (having title: String) -> Int {
        var currentSelection = 3
        switch title {
        case "Sports":
            currentSelection = 1
        case "Halloween":
            currentSelection = 0
        case "Faces":
            currentSelection = 2
        default:
            break
        }
        return currentSelection
    }

}
