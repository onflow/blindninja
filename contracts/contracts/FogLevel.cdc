import "BlindNinjaCore"
import "GenericLevelComponents"
import "BlindNinjaLevel"

// This composable level provides an easy way to create a BlindNinja
// level using core blind ninja core interfaces as drivers within it.
pub contract FogLevel: BlindNinjaLevel {
  access(all) var name: String
  access(all) var map: {BlindNinjaCore.Map}
  access(all) var gameObjects: {Int: {BlindNinjaCore.GameObject}}
  access(all) var mechanics: [{BlindNinjaCore.GameMechanic}]
  access(all) var visuals: [{BlindNinjaCore.VisualElement}]
  access(all) var winConditions: [{BlindNinjaCore.WinCondition}]
  access(all) var gameboard: BlindNinjaCore.GameBoard
  access(all) var state: {String: AnyStruct}

  access(all) fun initializeLevel() {
    // Final set of game objects are provided via this object.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    
    // Create the ninja for the map
    let ninja = GenericLevelComponents.GenericNinja(id: 1)
    ninja.setReferencePoint([4,4])
    gameObjects[Int(ninja.id)] = ninja

    // Create the flag to place on the map
    let flag = GenericLevelComponents.Flag(id: 2)
    flag.setReferencePoint([10,5])
    gameObjects[Int(flag.id)] = flag

    // Create 3 wall objects right in front of
    // where the flag was placed
    var y = 3
    var wallID = 3
    while (wallID <= 5) {
      let wall = GenericLevelComponents.Wall(id: UInt64(wallID))
      wall.setReferencePoint([5,y])
      gameObjects[Int(wall.id)] = wall
      y = y + 1
      wallID = wallID + 1
    }

    y = 0
    while (wallID <= 15) {
      let wall = GenericLevelComponents.Wall(id: UInt64(wallID))
      wall.setReferencePoint([3,y])
      gameObjects[Int(wall.id)] = wall
      y = y + 1
      wallID = wallID + 1
    }

    // Create a move mechanic which makes it so that
    // the ninja moves according to the inputted sequence
    // for the level.
    let moveMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.NinjaMovement(ninjaID: 1)

    // Create a wall mechanic, that makes it so that if a ninja
    // runs into the wall, their movement is reverted back.
    // This is to meant to run after the move mechanic.
    let wallMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.WallMechanic(ninjaID: 1, wallType: Type<GenericLevelComponents.Wall>())

    // Center the camera around the ninja at the end of each tick.
    let centeredCameraMechanic: {BlindNinjaCore.GameMechanic} = GenericLevelComponents.CenteredCamera(centeredObjectID: 1)

    // Create a win condition for the level, where the ninja
    // must touch the flag to win.
    let winCondition = GenericLevelComponents.NinjaTouchGoal(
      ninjaID: ninja.id,
      goalID: flag.id
    )

    // Set all of the contract level variables
    self.name = "Intro Level"
    self.map = GenericLevelComponents.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 9,
      viewHeight: 9
    )
    self.gameObjects = gameObjects
    self.mechanics = [ moveMechanic, wallMechanic, centeredCameraMechanic ]
    self.visuals = []
    self.winConditions = [ winCondition ]
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }

  // This init doesn't really matter, as 'initializeGame' must be called before each interaction with this game.
  // This is setup like this so that the contract can be updated, and the game will reflect those updates.
  // If you want an immutable game that is never updateable, you can skip implementing the 'initializeLevel' and
  // instead, and move all initialization code to 'init' below
  init() {
    self.name = "Intro Level"
    self.map = GenericLevelComponents.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 20,
      viewHeight: 20
    )
    self.gameObjects = {}
    self.mechanics = []
    self.visuals = []
    self.winConditions = []
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }
}
