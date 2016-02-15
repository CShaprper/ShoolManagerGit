
import UIKit

class IconPickerCell: UICollectionViewCell {
    @IBOutlet var IconImage: UIImageView!

    func configureCell(imagePath:String){
        IconImage.image = UIImage(named: imagePath)
    }
}
