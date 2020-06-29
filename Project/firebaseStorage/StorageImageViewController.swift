//
//  StorageImageViewController.swift
//  Project
//
//  Created by raz cohen on 12/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import FirebaseUI

class StorageImageViewController: UIViewController {
    
    var url = ""
    var images:[FirebaseExpense] = []
    
    //MARK: oulets
    
    @IBOutlet weak var arrowBackImage: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: actions
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let arrowImage = arrowBackImage.currentImage else{return}
        let resizedArrow = arrowImage.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1))
        arrowBackImage.setImage(resizedArrow, for: .normal)
        
        //read from firebase
        FirebaseExpense.imageDatabseRef.observe(.childAdded) {[weak self] (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any],
                let image = FirebaseExpense(dict: dict)else{
                    return
            }
            
            // add the image to the images array
            self?.images.append(image)
            getImage(fbE: image)
        }
        
        func getImage(fbE:FirebaseExpense){
            
            let ref = fbE.imageRef
            let imageURL = fbE.imageURL
            if imageURL == url{
                imageView.sd_setImage(with: ref)
                
                //placeHolder:
                imageView.sd_setImage(with: ref , placeholderImage: #imageLiteral(resourceName: "wallet"))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setDarkMode(view: self.view, labels: nil)
    }
}

extension StorageImageViewController:ScreenMode{}
