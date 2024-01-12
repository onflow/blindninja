import "BlindNinjaCore"
import "BlindNinjaGameObject"

access(all) contract Wall: BlindNinjaGameObject {
  access(all) struct GameObject: BlindNinjaCore.GameObject {
    access(all) var name: String
    access(all) var description: String
    access(all) var id: UInt64
    access(all) var type: String
    access(all) var referencePoint: [Int]
    access(all) var display: String

    init(id: UInt64) {
      self.id = id
      self.type = "Wall"
      self.referencePoint = [0,0]
      self.display = "🧱"
      self.name = "Wall"
      self.description = "A wall object in the game."
    }
  }
}