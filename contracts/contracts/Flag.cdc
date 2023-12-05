import "BlindNinjaCore"
import "BlindNinjaGameObject"

pub contract Flag: BlindNinjaGameObject {
  pub struct GameObject: BlindNinjaCore.GameObject {
    pub var name: String
    pub var description: String
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]
    pub var display: String

    init(id: UInt64) {
      self.id = id
      self.type = "Flag"
      self.referencePoint = [0,0]
      self.display = "🏁"
      self.name = "Flag"
      self.description = "A flag object in the game."
    }
  }
}