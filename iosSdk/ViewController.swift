//
//  ViewController.swift
//  iosSdk
//
//  Created by peach on 2019/11/19.
//  Copyright © 2019 com.wisdom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let y = "1000000000000000000000000000000000000000000"
        
        var mBytes:[UInt8]  =  [0,0,0,0,0,1];
        
        var data:Data = Data(bytes: mBytes, count: mBytes.count);
        
        var bytes = [UInt8](data)
        
        print(bytes)
        

        
        
            // x == 21
        ///     let y = Int(-21.5)
        ///     // y == -21
        
        // Do any additional setup after loading the view.
    }


}

