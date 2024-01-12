import "BlindNinjaCore"
import "BlindNinjaWinCondition"

access(all) contract NinjaTouchGoalWinCondition: BlindNinjaWinCondition {
  access(all) struct WinCondition: BlindNinjaCore.WinCondition {
    access(all) let name: String
    access(all) let description: String
    access(all) let ninjaID: UInt64
    access(all) let goalID: UInt64

    access(all) fun check(_ level: &BlindNinjaCore.LevelSaveState): Bool {
      let collisionPoints: [[Int]] = level.gameboard.getNewCollisionPoints()
      // get collision ids at the new collision points
      for point in collisionPoints {
        let ids: [UInt64] = level.gameboard.getIDsAtPoint(point)
        var containsNinja = false
        var containsGoal = false
        for id in ids {
          containsNinja = containsNinja || id == self.ninjaID
          containsGoal = containsGoal || id == self.goalID
        }
        if (containsNinja && containsGoal) {
          return true
        }
        if (containsNinja || containsGoal) {
          return false
        }
      }
      return false
    }
    
    init(ninjaID: UInt64, goalID: UInt64) {
      self.name = "Ninja Touch Goal"
      self.description = "This win condition checks if the ninja has touched the goal."
      self.ninjaID = ninjaID
      self.goalID = goalID
    }
  }
}