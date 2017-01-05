import Foundation
import UIKit



public class AUNavigationMenuController: UINavigationController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    /////////////////////////
    //
    //  Variables
    //
    /////////////////////////
    
    
    // Whether or not the menu is open.
    public var open: Bool! = false;
    
    
    // The amount to pull the menu down by.
    private var pullAmount: CGFloat = CGFloat();
    
    
    // The collection view with all of the menu pages.
    private var collectionView: UICollectionView!;
    
    
    // The menu pages that take the user to different view controllers.
    public var menuItems = [NavigationMenuItem]();
    
    
    // Color of the text. Black by default.
    private var itemTextColor: UIColor = .black;
    
    
    // The spacing between items.
    private var spacing: CGFloat = 10;
    
    
    // The size of the menu items.
    private var itemSize: CGSize!;
    
    
    // The options so that variables can be changed.
    private var options: AUNavigationMenuOptions?;
    
    
    
    
    
    /////////////////////////
    //
    //  Initializers and Basic Setup
    //
    /////////////////////////
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        setupCollectionView();
        setupTapGesture();
        addMenuView();
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
        setupCollectionView();
        setupTapGesture();
        addMenuView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        setupCollectionView();
        setupTapGesture();
        addMenuView();
    }
    
    public override func didMove(toParentViewController parent: UIViewController?) {
        setupCollectionView();
        setupTapGesture();
        addMenuView();
    }
    
    
    
    
    
    
    
    /////////////////////////
    //
    //  Methods
    //
    /////////////////////////
    
    
    ///////// Setup //////////
    
    /* Sets up the navigation bar so that it can recognize taps by the user. */
    private func setupTapGesture() {
        // Add a tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AUNavigationMenuController.togglePulldownMenu));
        navigationBar.addGestureRecognizer(tapRecognizer);
    }
    
    
    /* Sets up the options. */
    public func configureOptions(options: AUNavigationMenuOptions) {
        self.options = options;
        
        if let color = options.itemTextColor {
            itemTextColor = color;
        }
        if let space = options.itemSpacing {
            spacing = space;
        }
        if let size = options.itemSize {
            itemSize = size;
        }
        
        self.collectionView.reloadData();
    }
    
    
    /* Setup what's needed for the collection view. */
    private func setupCollectionView() {
        pullAmount = UIScreen.main.bounds.height / 4 + 10;
        
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .horizontal;
        layout.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0);
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: pullAmount), collectionViewLayout: layout);
        collectionView!.register(AUNavigationMenuCell.self, forCellWithReuseIdentifier: "AUMenuCell");
        collectionView.alwaysBounceHorizontal = true;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.showsVerticalScrollIndicator = false;
    }
    
    
    
    /* Opens a pull down style menu. */
    @objc public func togglePulldownMenu() {
        
        // Open
        if(!open) {
            
            self.collectionView.frame.origin = CGPoint(x: 0, y: -self.pullAmount);
            self.view.bringSubview(toFront: self.collectionView);
            self.collectionView.isHidden = false;
            
            UIView.animate(withDuration: 0.35, delay: 0.2, options: [], animations: {
                
                self.navigationBar.frame.origin.y += self.pullAmount;
                self.collectionView.frame.origin.y += self.pullAmount;
                
            }, completion: { (bool: Bool) in
                
                self.open = true;
                
            });
        
        // Close
        } else {
            
            UIView.animate(withDuration: 0.35, delay: 0.2, options: [], animations: {
                
                self.navigationBar.frame.origin.y -= self.pullAmount;
                self.collectionView.frame.origin = CGPoint(x: 0, y: -self.pullAmount);
                
            }, completion: { (bool: Bool) in
                
                self.view.sendSubview(toBack: self.collectionView);
                self.open = false;
                self.collectionView.isHidden = true;
                
            });
            
        } // End of if-statement.
        
    }
    
    
    
    
    ////////// Adding Navigation Pages //////////
    
    private func addMenuView() {
        // Initialize the collection view
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: pullAmount);
        
        
        // Add the menu view to the container
        view.addSubview(collectionView);
        view.sendSubview(toBack: collectionView);
        if let _ = UINavigationBar.appearance().barTintColor {
            collectionView.backgroundColor = UINavigationBar.appearance().barTintColor;
        } else {
            collectionView.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 0.8);
        }
        collectionView.isHidden = true;
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        
        if options == nil {
            itemSize = CGSize(width: 115, height: pullAmount - 35);
            spacing = 10;
            itemTextColor = .black;
        } else {
            if let color = self.options?.itemTextColor {
                itemTextColor = color;
            }
            if let space = self.options?.itemSpacing {
                spacing = space;
            }
            if let size = self.options?.itemSize {
                itemSize = size;
            }
        }
    }
    
    
    
    /* Adds new menu item.
     */
    public func addMenuItem(item: NavigationMenuItem) {
        menuItems.append(item);
    }
    
        
    /* Appends a new menu item onto the menu.
     */
    public func addMenuItem(name: String, image: UIImage?, destination: UIViewController) {
        let n = NavigationMenuItem(name: name, image: image, navCont: self, destination: destination, completion: nil);
        menuItems.append(n);
        collectionView.reloadData();
    }
    
    
    /* Appends a new menu item onto the menu.
     @param completion - The actions that should be performed once the menu item is clicked on.
     */
    public func addMenuItem(name: String, image: UIImage?, destination: UIViewController, completion: (() -> Void)?) {
        let n = NavigationMenuItem(name: name, image: image, navCont: self, destination: destination, completion: completion);
        menuItems.append(n);
        collectionView.reloadData();
    }
    
    
    
    
    
    
    /////////// Collection View Stuff ////////////
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AUMenuCell", for: indexPath) as! AUNavigationMenuCell;
        
        cell.navMenuItem = menuItems[indexPath.item];
        cell.textLabel.textColor = itemTextColor;
        cell.setupLayout();
        
        return cell;
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = options?.itemSize {
            return (options?.itemSize)!;
        } else {
            return CGSize(width: 115, height: pullAmount - 35);
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let _ = options?.itemSpacing {
            return (options?.itemSpacing)!;
        } else {
            return 10;
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuItems[indexPath.item].goToDestination(toggle: true);
    }
    
}
