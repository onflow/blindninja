import "BlindNinjaCore"
import "BlindNinjaMechanic"

pub contract CenteredCameraMechanic: BlindNinjaMechanic {
  pub struct Mechanic: BlindNinjaCore.GameMechanic {
    pub let name: String
    pub let description: String
    pub let centeredObjectID: UInt64

    pub fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      let centeredObjectLocation: [Int] = level.gameObjects[Int(self.centeredObjectID)]!.referencePoint
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