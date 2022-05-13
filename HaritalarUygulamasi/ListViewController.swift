//
//  ListViewController.swift
//  HaritalarUygulamasi
//
//  Created by Evren Ustun on 12.05.2022.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var isimArray = [String]()
    var idArray = [UUID]()
    var secilenYerIsim = ""
    var secilenYerId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(artiButtonClicked))
        
        veriAl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(veriAl), name: NSNotification.Name("addedNewPlace"), object: nil)
        
    }
    
    @objc func veriAl(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
        request.returnsObjectsAsFaults = false
        
        do{
            let sonuclar = try context.fetch(request)
            
            if sonuclar.count > 0 {
                
                isimArray.removeAll(keepingCapacity: false)
                idArray.removeAll(keepingCapacity: false)
                
                for sonuc in sonuclar as! [NSManagedObject] {
                    if let name = sonuc.value(forKey: "isim") as? String {
                        isimArray.append(name)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                }
                
                tableView.reloadData()
            }
            
        }catch{
            print("Hata")
        }
        
    }
    
    
    @objc func artiButtonClicked(){
        secilenYerIsim = ""
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        secilenYerIsim = isimArray[indexPath.row]
        secilenYerId = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toMapsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsVC"{
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.secilenIsim = secilenYerIsim
            destinationVC.secilenId = secilenYerId
        }
    }
    
    

}
