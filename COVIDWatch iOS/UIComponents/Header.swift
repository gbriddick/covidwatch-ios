//
//  Header.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/6/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import UIKit

class Header: UIView {
    var logo = UIImageView(image: UIImage(named: "logo-cw-color"))
    var menuIcon = UIView()
    var xIcon = UIView()
    var menu = UIView()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1))
    }
    
    func draw() {
        self.frame.origin.y = self.parentViewController!.view.safeAreaInsets.top
        self.parentViewController!.view.addSubview(self)
//        NOTE: the order of drawing here matters
        drawLogo()
        drawMenuIcon()
        drawMenu()
        drawXIcon()
    }
    
    private func drawLogo() {
        logo.frame.size.width = 41
        logo.frame.size.height = 39
        logo.center.x = 0.1 * self.frame.size.width
        logo.center.y = self.frame.midY
        parentViewController!.view.addSubview(logo)
    }

    private func drawMenuIcon() {
        menuIcon.backgroundColor = UIColor(patternImage: UIImage(named: "menu-icon")!)
        menuIcon.frame.size.width = 36
        menuIcon.frame.size.height = 24
        menuIcon.center.x = 0.9 * self.frame.size.width
        menuIcon.center.y = self.frame.midY
        menuIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        parentViewController!.view.addSubview(menuIcon)
    }
    
    private func drawMenu() {
        menu.frame.size.width = 0.8 * UIScreen.main.bounds.width
        menu.frame.size.height = UIScreen.main.bounds.height
        menu.frame.origin.x = UIScreen.main.bounds.width - menu.frame.size.width
        menu.frame.origin.y = self.frame.minY
        menu.isHidden = true
        menu.backgroundColor = .red
        parentViewController!.view.addSubview(menu)
    }
    
    private func drawXIcon() {
        xIcon.backgroundColor = UIColor(patternImage: UIImage(named: "x-icon")!)
        xIcon.frame.size.width = 28
        xIcon.frame.size.height = 28
        xIcon.center = menuIcon.center
        xIcon.isHidden = true
        xIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleMenu)))
        parentViewController!.view.addSubview(xIcon)
    }
        
    @objc func toggleMenu() {
        menu.isHidden = !menu.isHidden
        xIcon.isHidden = !xIcon.isHidden
        menuIcon.isHidden = !menuIcon.isHidden
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}