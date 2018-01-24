//
//  TavernDetailViewController.swift
//  Habitica
//
//  Created by Phillip Thelen on 17.01.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import UIKit

class TavernDetailViewController: UIViewController {
    
    @IBOutlet weak var tavernHeaderView: HRPGShopBannerView!
    
    @IBOutlet weak var innButton: UIButton!
    @IBOutlet weak var worldBossStackView: CollapsibleStackView!
    @IBOutlet weak var innStackView: CollapsibleStackView!
    @IBOutlet weak var guidelinesStackView: CollapsibleStackView!
    @IBOutlet weak var linksStackView: CollapsibleStackView!
    @IBOutlet weak var questProgressView: QuestProgressView!
    
    var group: Group? {
        didSet {
            if let group = self.group {
                questProgressView.configure(group: group)
            }
        }
    }
    var quest: Quest? {
        didSet {
            if let quest = self.quest {
                questProgressView.configure(quest: quest)
                tavernHeaderView.setNotes(NSLocalizedString("Oh dear, pay no heed to the monster below -- this is still a safe haven to chat on your breaks.", comment: ""))
                questProgressView.isHidden = false
            } else {
                questProgressView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tavernHeaderView.shopNameLabel.text = "Daniel"
        tavernHeaderView.setSprites(identifier: "tavern")
        tavernHeaderView.setNotes(NSLocalizedString("Welcome to the Inn! Pull up a chair to chat, or take a break from your tasks.", comment: ""))
        
        let margins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        worldBossStackView.layoutMargins = margins
        worldBossStackView.isLayoutMarginsRelativeArrangement = true
        innStackView.layoutMargins = margins
        innStackView.isLayoutMarginsRelativeArrangement = true
        guidelinesStackView.layoutMargins = margins
        guidelinesStackView.isLayoutMarginsRelativeArrangement = true
        linksStackView.layoutMargins = margins
        linksStackView.isLayoutMarginsRelativeArrangement = true
        configureInnButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //workaround to get the view to size correctly.
        worldBossStackView.isCollapsed = worldBossStackView.isCollapsed
    }
    
    @IBAction func innButtonTapped(_ sender: Any) {
        self.configureInnButton(disabled: true)
        HRPGManager.shared().sleepInn({[weak self] in
            self?.configureInnButton()
        }, onError: {[weak self] in
            self?.configureInnButton()
        })
    }
    
    @IBAction func guidelinesButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "GuidelinesSegue", sender: self)
    }
    
    @IBAction func faqButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FAQOverviewViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func reportBugButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func configureInnButton(disabled: Bool = false) {
        innButton.isEnabled = !disabled
        if HRPGManager.shared().getUser().preferences.sleep?.boolValue ?? false {
            innButton.setTitle(NSLocalizedString("Resume Damage", comment: ""), for: .normal)
        } else {
            innButton.setTitle(NSLocalizedString("Pause Damage", comment: ""), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GuidelinesSegue" {
            let navigationController = segue.destination as? UINavigationController
            let guidelinesController = navigationController?.topViewController as? HRPGGGuidelinesViewController
            guidelinesController?.needsAccepting = !(HRPGManager.shared().getUser().flags.communityGuidelinesAccepted?.boolValue ?? false)
        }
    }
}