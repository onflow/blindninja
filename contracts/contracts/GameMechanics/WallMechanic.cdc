import "BlindNinjaCore"
import "BlindNinjaMechanic"

access(all) contract WallMechanic: BlindNinjaMechanic {
  access(all) struct Mechanic: BlindNinjaCore.GameMechanic {
    access(all) let name: String
    access(all) let description: String
    access(all) let ninjaID: UInt64
    access(all) let wallType: Type

    access(all) fun tick(_ level: &BlindNinjaCore.LevelSaveState) {
      // Check through the new collisions that have come up,
      // If any have to do with the ninja colliding with a
      // wall type, then revert the ninja to go back to its
      // location from the previous game result.
      let collisionPoints = level.gameboard.getNewCollisionPoints()
      
      var ninjaHasRunIntoWall = false
      for point in collisionPoints {
        let ids: [UInt64] = level.gameboard.getIDsAtPoint(point)
        var containsNinja = false
        var containsWallType = false
        for id in ids {
          containsNinja = containsNinja || id == self.ninjaID
          containsWallType = containsWallType || self.wallType == level.gameObjects[Int(id)]!.getType()
        }
        if (containsNinja && containsWallType) {
          ninjaHasRunIntoWall = true
          break
        }
        if (containsNinja || containsWallType) {
          ninjaHasRunIntoWall = false
          break
        }
      }

      if (ninjaHasRunIntoWall) {
        // If the ninja is currently running into a wall,
        // revert the ninja to its previous position from before
        // this move.
        let prevNinja = level.tickResults[Int(level.tickResults.length - 1)]!.getGameObject(Int(self.ninjaID))!
        let curNinja = level.getGameObject(Int(self.ninjaID))!
        level.gameboard.remove(curNinja)
        level.gameboard.add(prevNinja)
        level.setGameObject(Int(self.ninjaID), prevNinja)
      }
    }

    init(ninjaID: UInt64, wallType: Type) {
      self.name = "Wall blocks ninja"
      self.description = "This mechanic prevents the ninjas with a given ID from moving into a wall of a given struct type."
      self.ninjaID = ninjaID
      self.wallType = wallType
    }
  }
}
