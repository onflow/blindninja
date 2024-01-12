import "BlindNinjaCore"
import "BlindNinjaMechanic"

access(all) contract CenteredCameraMechanic: BlindNinjaMechanic {
  access(all) struct Mechanic: BlindNinjaCore.GameMechanic {
    access(all) let name: String
    access(all) let description: String
    access(all) let centeredObjectID: UInt64

    access(all) fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let centeredObjectLocation: [Int] = level.getGameObject(Int(self.centeredObjectID))!.referencePoint
      let newAnchorX = centeredObjectLocation[0]! - (level.map.viewWidth/2)
      let newAnchorY = centeredObjectLocation[1]! - (level.map.viewHeight/2)
      let newMap: BlindNinjaCore.Map = BlindNinjaCore.Map(
        anchorX: newAnchorX,
        anchorY: newAnchorY,
        viewWidth: level.map.viewWidth,
        viewHeight: level.map.viewHeight
      )
      level.setMap(newMap)
    }

    init(centeredObjectID: UInt64) {
      self.name = "Centered Camera"
      self.description = "This mechanic centers the camera on the object with the provided ID."
      self.centeredObjectID = centeredObjectID
    }
  }
}