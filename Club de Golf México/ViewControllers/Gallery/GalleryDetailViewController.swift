//
//  GalleryDetailViewController.swift
//  Club de Golf México
//
//  Created by admin on 2/26/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Gradientable
import MBProgressHUD
import RIGImageGallery

class GalleryDetailViewController: UIViewController {

    var gallery: GaleriasType!
    
    @IBOutlet var gradientableView: GradientableView!
    
    @IBOutlet var toggleButton: GradientableButton!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var resenaView: UIView!
    
    @IBOutlet var descriptionLabel: UITextView!
    
    @IBOutlet var resenaTextView: UITextView!
    
    var galleryList = [String]()
    var image: UIImage = UIImage()
    
    fileprivate let imageSession = URLSession(configuration: .default)

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = gallery.galeria_titulo
        
        descriptionLabel.text = gallery.galeria_contenido
        
        resenaTextView.text = gallery.galeria_resena
        
        if gallery.galeria_resena != "" {
            toggleButton.isHidden = false
            resenaView.isHidden = false
        } else {
            toggleButton.isHidden = true
            resenaView.isHidden = true
        }
        
        let imageURL = WebService.shared.serverURL + WebService.shared.serverFiles + "m/" + (gallery.timeStamp.dateFromISO8601?.yearMonthPath)! + "/" + gallery.galeria_image
        mainImageView.image = UIImage.placeHolder
        mainImageView.af_setImage(withURL: URL(string: imageURL)!)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        WebService.shared.sendRequest(codigo: 230, data: [gallery.galeria_path]) { (isSuccess, errorMessage, responseResult) in
        
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if isSuccess {
                let count = Int(responseResult![3])!
                
                for i in 0..<count {
                    let url = WebService.shared.serverURL + WebService.shared.serverFiles + "g" + responseResult![2] + responseResult![4+i]
                    self.galleryList.append(url)
                }
                
                self.collectionView.reloadData()
                
            }
            
            
        }

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let logoGradient = GradientableOptions(colors: [UIColor.primary, UIColor.colorAccent, UIColor.primary], locations: nil, direction: GradientableOptionsDirection.bottomRightToTopLeft)
        gradientableView.set(options: logoGradient)
        
        let toggleGradient = GradientableOptions(colors: [UIColor(red: 250/255.0, green: 227/255.0, blue: 209/255.0, alpha: 1), .colorAccent])
        toggleButton.set(options: toggleGradient)

    }
    
    
    @IBAction func toggleButtonClick(_ sender: Any) {
        self.toggleButton.isSelected = !self.toggleButton.isSelected
        if self.toggleButton.isSelected {
            resenaView.isHidden = false
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
            resenaView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GalleryDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItem", for: indexPath)
        
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            
            imageView.image = UIImage.placeHolder

            imageView.af_setImage(withURL: URL(string: galleryList[indexPath.row])!)

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.size.width-21) / 3;
        return CGSize(width: width, height: width);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoViewController = prepareRemoteGallery()
        photoViewController.dismissHandler = dismissPhotoViewer
        photoViewController.actionButtonHandler = actionButtonHandler
        photoViewController.actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
        photoViewController.traitCollectionChangeHandler = traitCollectionChangeHandler
        photoViewController.setCurrentImage(indexPath.row, animated: false)
        
        let cell = collectionView.cellForItem(at: indexPath)
        let imageView = cell?.viewWithTag(100) as? UIImageView
        self.image = (imageView?.image)!
        
        

        let navigationController = navBarWrappedViewController(photoViewController)
        present(navigationController, animated: true, completion: nil)

    }
    
}

private extension GalleryDetailViewController {
    func dismissPhotoViewer(_ :RIGImageGalleryViewController) {
        dismiss(animated: true, completion: nil)
    }
    func traitCollectionChangeHandler(_ photoView: RIGImageGalleryViewController) {
        let isPhone = UITraitCollection(userInterfaceIdiom: .phone)
        let isCompact = UITraitCollection(verticalSizeClass: .compact)
        let allTraits = UITraitCollection(traitsFrom: [isPhone, isCompact])
        photoView.doneButton = photoView.traitCollection.containsTraits(in: allTraits) ? nil : UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    }
    
    func navBarWrappedViewController(_ viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barStyle = .blackTranslucent
        navigationController.navigationBar.tintColor = .white
        navigationController.toolbar.barStyle = .blackTranslucent
        navigationController.toolbar.tintColor = .white
        return navigationController
    }

    func actionButtonHandler(rigVC :RIGImageGalleryViewController, galleryItem: RIGImageGalleryItem) {
        // set up activity view controller
        let imageToShare = [ self.image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        //activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        rigVC.present(activityViewController, animated: true, completion: nil)
    }

    func prepareRemoteGallery() -> RIGImageGalleryViewController {
        
        let urls = galleryList.flatMap(URL.init(string:))
        
        let rigItems: [RIGImageGalleryItem] = urls.map { url in
            
            RIGImageGalleryItem(placeholderImage: nil,
                                title: url.pathComponents.last ?? "",
                                isLoading: true)
        }
        
        let rigController = RIGImageGalleryViewController(images: rigItems)
        
        for (index, URL) in  urls.enumerated() {
            let completion = rigController.handleImageLoadAtIndex(index)
            let request = imageSession.dataTask(with: URLRequest(url: URL),
                                                completionHandler: completion)
            request.resume()
        }
        
        return rigController
    }
    

}

extension RIGImageGalleryViewController {
    // swiftlint:disable:next large_tuple
    func handleImageLoadAtIndex(_ index: Int) -> ((Data?, URLResponse?, Error?) -> Void) {
        return { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let image = data.flatMap(UIImage.init), error == nil else {
                if let error = error {
                    print(error)
                }
                return
            }
            self?.images[index].isLoading = false
            self?.images[index].image = image
        }
    }
}
