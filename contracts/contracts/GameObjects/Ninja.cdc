import "BlindNinjaCore"
import "BlindNinjaGameObject"

access(all) contract Ninja: BlindNinjaGameObject {
  access(all) struct GameObject: BlindNinjaCore.GameObject {
    access(all) var name: String
    access(all) var description: String
    access(all) var id: UInt64
    access(all) var type: String
    access(all) var referencePoint: [Int]
    access(all) var display: String

    init(id: UInt64) {
      self.id = id
      self.type = "BlindNinja"
      self.referencePoint = [0,0]
      self.display = "🥷"
      self.name = "Generic Ninja"
      self.description = "A generic ninja character in the game."
    }
  }
}