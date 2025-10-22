//
//  MenuView.swift
//  ballTouch
//
//  Created by najak on 10/15/25.
//

import SwiftUI

class MenuButton: UIButton {
    
    var actionHandler: ((Int) -> Void)? = nil
    var selectedIndex: Int = 0
    
    init(frame: CGRect, selectionIndex: Int) {
        super.init(frame: frame)
        
        let second10Action = self.second10Action(0)
        let second20Action = self.second20Action(1)
        let second30Action = self.second30Action(2)
        let second40Action = self.second40Action(3)
        let second50Action = self.second50Action(4)
        let second60Action = self.second60Action(5)
        let second70Action = self.second70Action(6)
        let second80Action = self.second80Action(7)
        let second90Action = self.second90Action(8)
        let second100Action = self.second100Action(9)

        setTitle("\((selectionIndex + 1) * 10)초", for: .normal)
        setTitleColor(UIColor(named: "1F2020"), for: .normal)
        titleLabel?.font = UIFont(name: "GmarketSansTTFBold", size: 16)
#if __NOT_USE__
        menu = UIMenu(title: "", children: [second10Action, second20Action, second30Action, second40Action, second50Action,
                                           second60Action, second70Action, second80Action, second90Action, second100Action])
#else
        menu = UIMenu(title: "", children: [second10Action, second20Action, second30Action, second40Action, second50Action,
                                           second60Action])

#endif
        menu?.preferredElementSize = .automatic
        showsMenuAsPrimaryAction = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getButtonTitle(_ index: Int) -> String {
        return "\((index + 1) * 10)초"
    }
    
    func buttonTitle(_ selectionIndex: Int) {
        setTitle("\((selectionIndex + 1) * 10)초", for: .normal)
        self.actionHandler?(selectionIndex)
    }
    
    func second10Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second20Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
        
    func second30Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second40Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second50Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second60Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second70Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second80Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second90Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
    
    func second100Action(_ index: Int) -> UIAction {
        UIAction(title: getButtonTitle(index)) { action in
            self.buttonTitle(index)
        }
    }
}
