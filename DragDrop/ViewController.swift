//
//  ViewController.swift
//  DragDrop
//
//  Created by Deveesh on 17/10/19.
//  Copyright © 2019 MindfireSolutions. All rights reserved.
//
import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableToDragItemsFrom: UITableView!
    @IBOutlet weak var imageToDropItemsOn: UIImageView!
    
    /// Data to fill in tableview
    var sampleData : [NSString] = ["A", "B", "C", "D", "E",
                                  "F", "G","H","I","J","K"]
    
    // MARK: Initialisation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView will only have items dragged from it
        tableToDragItemsFrom.dragDelegate = self
        tableToDragItemsFrom.dragInteractionEnabled = true
        
        //ImageView will only have items dropped on it
        let interDrop = UIDropInteraction(delegate: self)
        imageToDropItemsOn.addInteraction(interDrop)
        
        //Enabling user interaction is needed to make dropping functionality work
        imageToDropItemsOn.isUserInteractionEnabled = true
        self.imageToDropItemsOn.backgroundColor = UIColor.red
    }
}

extension ViewController: UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("CAN HANDLE")
        //Can we handle objects of type DraggableInteger?
        return session.canLoadObjects(ofClass: DraggableInteger.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        print("DID ENTER")
        //This is needed to reset the state of the UIIView to that when animation wasn't started. This is so that
        //animation can start back again.
        //Without reseting the animation will not start again once it is stopped. To start it back again, those
        //properties which are changed in animation need to be reset back
        self.imageToDropItemsOn.backgroundColor = UIColor.red
        self.imageToDropItemsOn.tintColor = UIColor.white

        //Start animation
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.imageToDropItemsOn.backgroundColor = UIColor.white
            self.imageToDropItemsOn.tintColor = UIColor.red
        }, completion: nil)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print("DID UPDATE")
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items
        print("PERFORM DROP")
        session.loadObjects(ofClass: DraggableInteger.self) { int in
            let val = int as? [DraggableInteger]
            let idx = val?[0].integerValue ?? -1
            
            if idx != -1{
                self.sampleData.remove(at: idx)
                self.tableToDragItemsFrom.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
            }
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession){
        print("DID EXIT")
        self.imageToDropItemsOn.layer.removeAllAnimations()
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print("DID END")
        //No need to stop animation here again as sessionDidEnd is always called AFTER sessionDidExit
    }
}

//MARK: TableView delegates
extension ViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if( !(cell != nil)) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        cell!.textLabel?.text = sampleData[indexPath.row] as String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let int = DraggableInteger(value: indexPath.row)
        let itemProvider = NSItemProvider(object: int)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        return [dragItem]
    }
}
