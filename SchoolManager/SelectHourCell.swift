

import UIKit

class SelectHourCell: UITableViewCell {
    /*@IBOutlet
    ###############################################################################################################*/
    @IBOutlet var HoursCounterImg1: UIImageView!
    @IBOutlet var HoursCounterImg2: UIImageView!
    @IBOutlet var HoursViewerImg1: UIImageView!
    @IBOutlet var HoursViewerImg2: UIImageView!
    @IBOutlet var MinutesViewerImg1: UIImageView!
    @IBOutlet var MinutesViewerImg2: UIImageView!
    @IBOutlet var EndHoursViewerImg1: UIImageView!
    @IBOutlet var EndHoursViewerImg2: UIImageView!
    @IBOutlet var EndMinutesViewer1: UIImageView!
    @IBOutlet var EndMinutesViewer2: UIImageView!
    
    func cofigureCell(timeline:TimelineData){
        let hour = timeline.hour!.integerValue
        
        switch hour{
        case 1:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock1")!
            break
        case 2:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock2")!
            break
        case 3:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock3")!
            break
        case 4:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock4")!
            break
        case 5:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock5")!
            break
        case 6:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock6")!
            break
        case 7:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock7")!
            break
        case 8:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock8")!
            break
        case 9:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock9")!
            break
        case 10:
            HoursCounterImg1.image = UIImage(named:"FlipClock1")!
            HoursCounterImg2.image = UIImage(named:"FlipClock0")!
            break
        case 11:
            HoursCounterImg1.image = UIImage(named:"FlipClock1")!
            HoursCounterImg2.image = UIImage(named:"FlipClock1")!
            break
        case 12:
            HoursCounterImg1.image = UIImage(named:"FlipClock1")!
            HoursCounterImg2.image = UIImage(named:"FlipClock2")!
            break
        case 13:
            HoursCounterImg1.image = UIImage(named:"FlipClock1")!
            HoursCounterImg2.image = UIImage(named:"FlipClock3")!
            break
        case 14:
            HoursCounterImg1.image = UIImage(named:"FlipClock1")!
            HoursCounterImg2.image = UIImage(named:"FlipClock4")!
            break
        default:
            HoursCounterImg1.image = UIImage(named:"FlipClock0")!
            HoursCounterImg2.image = UIImage(named:"FlipClock0")!
            break
        }
        
        let starthour = DateHelper.GetTimeAsHour(timeline.startTime!)
        switch  starthour{
        case 1:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 2:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 3:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 4:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 5:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 6:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 7:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 8:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 9:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 10:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 11:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 12:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 13:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 14:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 15:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 16:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 17:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 18:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 19:
            HoursViewerImg1.image = UIImage(named:"FlipClock1")!
            HoursViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 20:
            HoursViewerImg1.image = UIImage(named:"FlipClock2")!
            HoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 21:
            HoursViewerImg1.image = UIImage(named:"FlipClock2")!
            HoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 22:
            HoursViewerImg1.image = UIImage(named:"FlipClock2")!
            HoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 23:
            HoursViewerImg1.image = UIImage(named:"FlipClock2")!
            HoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 24:
            HoursViewerImg1.image = UIImage(named:"FlipClock2")!
            HoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        default:
            HoursViewerImg1.image = UIImage(named:"FlipClock0")!
            HoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        }
        
        let starminute = DateHelper.GetTimeAsMinute(timeline.startTime!)
        switch  starminute{
        case 1:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 2:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 3:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 4:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 5:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 6:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 7:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 8:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 9:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 10:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 11:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 12:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 13:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 14:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 15:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 16:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 17:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 18:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 19:
            MinutesViewerImg1.image = UIImage(named:"FlipClock1")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 20:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 21:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 22:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 23:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 24:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 25:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 26:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 27:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 28:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 29:
            MinutesViewerImg1.image = UIImage(named:"FlipClock2")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 30:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 31:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 32:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 33:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 34:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 35:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 36:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 37:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 38:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 39:
            MinutesViewerImg1.image = UIImage(named:"FlipClock3")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 40:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 41:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 42:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 43:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 44:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 45:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 46:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 47:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 48:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 49:
            MinutesViewerImg1.image = UIImage(named:"FlipClock4")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 50:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 51:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 52:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 53:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 54:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 55:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 56:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 57:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 58:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 59:
            MinutesViewerImg1.image = UIImage(named:"FlipClock5")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 60:
            MinutesViewerImg1.image = UIImage(named:"FlipClock6")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        default:
            MinutesViewerImg1.image = UIImage(named:"FlipClock0")!
            MinutesViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        }
        
        let endhour = DateHelper.GetTimeAsHour(timeline.endTime!)
        switch endhour{
        case 1:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 2:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 3:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 4:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 5:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 6:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 7:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 8:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 9:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 10:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 11:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 12:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 13:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 14:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        case 15:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock5")!
            break
        case 16:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock6")!
            break
        case 17:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock7")!
            break
        case 18:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock8")!
            break
        case 19:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock1")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock9")!
            break
        case 20:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock2")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        case 21:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock2")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock1")!
            break
        case 22:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock2")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock2")!
            break
        case 23:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock2")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock3")!
            break
        case 24:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock2")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock4")!
            break
        default:
            EndHoursViewerImg1.image = UIImage(named:"FlipClock0")!
            EndHoursViewerImg2.image = UIImage(named:"FlipClock0")!
            break
        }
        
        let endminute = DateHelper.GetTimeAsMinute(timeline.endTime!)
        switch  endminute{
        case 1:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 2:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 3:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 4:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 5:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 6:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 7:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 8:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 9:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 10:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        case 11:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 12:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 13:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 14:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 15:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 16:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 17:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 18:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 19:
            EndMinutesViewer1.image = UIImage(named:"FlipClock1")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 20:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        case 21:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 22:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 23:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 24:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 25:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 26:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 27:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 28:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 29:
            EndMinutesViewer1.image = UIImage(named:"FlipClock2")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 30:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        case 31:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 32:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 33:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 34:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 35:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 36:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 37:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 38:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 39:
            EndMinutesViewer1.image = UIImage(named:"FlipClock3")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 40:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        case 41:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 42:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 43:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 44:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 45:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 46:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 47:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 48:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 49:
            EndMinutesViewer1.image = UIImage(named:"FlipClock4")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 50:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        case 51:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock1")!
            break
        case 52:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock2")!
            break
        case 53:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock3")!
            break
        case 54:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock4")!
            break
        case 55:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock5")!
            break
        case 56:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock6")!
            break
        case 57:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock7")!
            break
        case 58:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock8")!
            break
        case 59:
            EndMinutesViewer1.image = UIImage(named:"FlipClock5")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock9")!
            break
        case 60:
            EndMinutesViewer1.image = UIImage(named:"FlipClock6")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        default:
            EndMinutesViewer1.image = UIImage(named:"FlipClock0")!
            EndMinutesViewer2.image = UIImage(named:"FlipClock0")!
            break
        }
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }
}
