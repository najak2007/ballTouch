//
//  MenuView.swift
//  ballTouch
//
//  Created by najak on 10/15/25.
//

import SwiftUI

class MenuButton: UIButton {
    
    var actionHandler: ((Int) -> Void)? = nil
    
    init(frame: CGRect, selectionIndex: Int) {
        super.init(frame: frame)
        
        let second10Action = self.second10Action()
        let second20Action = self.second20Action()
        let second30Action = self.second30Action()
        let second40Action = self.second40Action()
        let second50Action = self.second50Action()
        let second60Action = self.second60Action()
        let second70Action = self.second70Action()
        let second80Action = self.second80Action()
        let second90Action = self.second90Action()
        let second100Action = self.second100Action()

        setTitle("\((selectionIndex + 1) * 10)초", for: .normal)
        setTitleColor(UIColor(named: "1F2020"), for: .normal)
        titleLabel?.font = UIFont(name: "GmarketSansTTFBold", size: 16)
        menu = UIMenu(title: "", children: [second10Action, second20Action, second30Action, second40Action, second50Action,
                                           second60Action, second70Action, second80Action, second90Action, second100Action])
        menu?.preferredElementSize = .automatic
        showsMenuAsPrimaryAction = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonTitle(_ selectionIndex: Int) {
        setTitle("\((selectionIndex + 1) * 10)초", for: .normal)
        self.actionHandler?(selectionIndex)
    }
    
    func second10Action() -> UIAction {
        UIAction(title: "10초") { action in
            self.buttonTitle(0)
        }
    }
    
    func second20Action() -> UIAction {
        UIAction(title: "20초") { action in
            self.buttonTitle(1)
        }
    }
    
    
    func second30Action() -> UIAction {
        UIAction(title: "30초") { action in
            self.buttonTitle(2)
        }
    }
    
    func second40Action() -> UIAction {
        UIAction(title: "40초") { action in
            self.buttonTitle(3)
        }
    }
    
    func second50Action() -> UIAction {
        UIAction(title: "50초") { action in
            self.buttonTitle(4)
        }
    }
    
    func second60Action() -> UIAction {
        UIAction(title: "60초") { action in
            self.buttonTitle(5)
        }
    }
    
    func second70Action() -> UIAction {
        UIAction(title: "70초") { action in
            self.buttonTitle(6)
        }
    }
    
    func second80Action() -> UIAction {
        UIAction(title: "80초") { action in
            self.buttonTitle(7)
        }
    }
    
    func second90Action() -> UIAction {
        UIAction(title: "90초") { action in
            self.buttonTitle(8)
        }
    }
    
    func second100Action() -> UIAction {
        UIAction(title: "100초") { action in
            self.buttonTitle(9)
        }
    }
}
