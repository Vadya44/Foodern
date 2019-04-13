import UIKit
import UserNotifications
import UserNotificationsUI

class CreateNotifyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var datePickerView: UIView!
    let datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    var vSpinner: UIView?
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var textBodyView: UITextView!
    @IBOutlet weak var notifysTableView: UITableView!
    var cnt: Int = 0
    
    let center = UNUserNotificationCenter.current()
    
    var notifys: [UNNotificationRequest] = []
    
    let requestIdentifier = "foodern_not"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            
        })
        self.textBodyView.delegate = self
        self.notifysTableView.delegate = self
        self.notifysTableView.dataSource = self
        self.center.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.reloadData()
        cnt = notifys.count
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH.mm"
        let text = formatter.string(from: datePicker.date)
        self.dateBtn.titleLabel!.text = "на \(text)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showDatePicker(){
        //Formate Date
        self.showSpinner(onView: self.view)
        
        datePicker.frame = CGRect.init(x: 0, y: 0, width: datePickerView.intrinsicContentSize.width, height: datePickerView.intrinsicContentSize.height)
        datePicker.datePickerMode = .dateAndTime
        
        
        
        //ToolBar
        toolbar.frame = CGRect.init(x: 0, y: 0, width: datePickerView.intrinsicContentSize.width + 35, height: datePickerView.intrinsicContentSize.height + 35)
        toolbar.backgroundColor = UIColor.white
        //        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(CreateNotifyViewController.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(CreateNotifyViewController.cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        toolbar.addSubview(datePicker)
        toolbar.layer.cornerRadius = toolbar.frame.size.height / 15
        toolbar.layer.masksToBounds = true
        self.view.addSubview(toolbar)
        toolbar.center = self.view.center
        
        
        
        
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        
        DispatchQueue.main.async {
            spinnerView.addSubview(self.toolbar)
            onView.addSubview(spinnerView)
        }
        
        self.vSpinner = spinnerView
    }
    
    func removeSpinner() {
        self.toolbar.removeFromSuperview()
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        let text = formatter.string(from: datePicker.date)
        self.dateBtn.titleLabel!.text = "на \(text)"
        self.removeSpinner()
    }
    
    
    @objc func cancelDatePicker(){
        removeSpinner()
        
    }
    @IBAction func dimissVCBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eadas(_ sender: Any) {
        self.showDatePicker()
    }
    
    @IBAction func triggerButton(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "Foodern"
        content.subtitle = "Напоминание о покупке"
        content.body = textBodyView.text
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "\(requestIdentifier)\(cnt)", content: content, trigger: trigger)
        cnt = cnt + 1
    
        center.add(request){(error) in
            
            if (error != nil){
                
                
            }
        }
        
        self.reloadData()
        
    }
    
    
    @IBAction func stopButton(_ sender: Any) {
        print("Remove pending request.")
        let centre = UNUserNotificationCenter.current()
        var identifiers: [String] = [requestIdentifier]
        for i in 0...cnt {
            identifiers.append("\(requestIdentifier)\(i)")
        }
        centre.removePendingNotificationRequests(withIdentifiers: identifiers)
        self.reloadData()
    }
}

extension CreateNotifyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifyTableViewCell", for: indexPath) as! notifyTableViewCell
        cell.dateLabel.text = notifys[indexPath.row].content.subtitle
        if let calendarNotificationTrigger = notifys[indexPath.row].trigger as? UNCalendarNotificationTrigger,
            let nextTriggerDate = calendarNotificationTrigger.nextTriggerDate()  {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            cell.dateLabel.text = formatter.string(from: nextTriggerDate)
        }
        
        cell.descrLabel.text = notifys[indexPath.row].content.body
        return cell
    }
    
    
}


extension CreateNotifyViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier.contains(requestIdentifier){
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func reloadData() {
        center.getPendingNotificationRequests { (notifications) in
            self.notifys = notifications.filter({ (obj) -> Bool in
                return obj.identifier.contains(self.requestIdentifier)
            })
            DispatchQueue.main.async {
                self.notifysTableView.reloadData()
            }
        }
    }
}
