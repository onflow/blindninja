import "BlindNinjaCore"
import "BlindNinjaLevel"
import "Ninja"
import "Flag"
import "Wall"
import "NinjaMovementMechanic"
import "NinjaTouchGoalWinCondition"
import "WallMechanic"

// This composable level provides an easy way to create a BlindNinja
// level using core blind ninja core interfaces as drivers within it.
access(all) contract WallsLevel: BlindNinjaLevel {
  access(all) var name: String
  access(all) var map: BlindNinjaCore.Map
  access(all) var gameObjects: {Int: {BlindNinjaCore.GameObject}}
  access(all) var mechanics: [{BlindNinjaCore.GameMechanic}]
  access(all) var visuals: [{BlindNinjaCore.VisualElement}]
  access(all) var winConditions: [{BlindNinjaCore.WinCondition}]
  access(all) var gameboard: BlindNinjaCore.GameBoard
  access(all) var state: {String: AnyStruct}

  access(all) fun initializeLevel() {
    // Create the ninja for the map
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}

    let ninja = Ninja.GameObject(id: 1)
    ninja.setReferencePoint([5,5])
    gameObjects[Int(ninja.id)] = ninja

    // Create the flag to place on the map
    let flag = Flag.GameObject(id: 2)
    flag.setReferencePoint([8,5])
    gameObjects[Int(flag.id)] = flag

    // Create 3 wall objects right in front of
    // where the flag was placed
    var y = 4
    var wallID = 3
    while (wallID <= 5) {
      let wall = Wall.GameObject(id: UInt64(wallID))
      wall.setReferencePoint([7,y])
      gameObjects[Int(wall.id)] = wall
      y = y + 1
      wallID = wallID + 1
    }

    // Create a move mechanic which makes it so that
    // the ninja moves according to the inputted sequence
    // for the level.
    let moveMechanic: {BlindNinjaCore.GameMechanic} = NinjaMovementMechanic.Mechanic(ninjaID: 1)

    // Create a wall mechanic, that makes it so that if a ninja
    // runs into the wall, their movement is reverted back.
    // This is to meant to run after the move mechanic.
    let wallMechanic: {BlindNinjaCore.GameMechanic} = WallMechanic.Mechanic(ninjaID: 1, wallType: Type<Wall.GameObject>())

    // Create a win condition for the level, where the ninja
    // must touch the flag to win.
    let winCondition = NinjaTouchGoalWinCondition.WinCondition(
      ninjaID: ninja.id,
      goalID: flag.id
    )

    // Set all of the contract level variables
    self.name = "Walls Level"
    self.map = BlindNinjaCore.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 20,
      viewHeight: 20
    )
    self.gameObjects = gameObjects
    self.mechanics = [ moveMechanic, wallMechanic ]
    self.visuals = []
    self.winConditions = [ winCondition ]
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }


  init() {
    // This init doesn't really matter, as 'initializeGame' must be called before each interaction with this game.
    // This is setup like this so that the contract can be updated, and the game will reflect those updates.
    let gameObjects: {Int: {BlindNinjaCore.GameObject}} = {}
    self.name = "Intro Level"
    self.map = BlindNinjaCore.Map(
      anchorX: 0,
      anchorY: 0,
      viewWidth: 20,
      viewHeight: 20
    )
    self.gameObjects = gameObjects
    self.mechanics = []
    self.visuals = []
    self.winConditions = []
    self.gameboard = BlindNinjaCore.GameBoard()
    self.state = {}
    self.addObjectsToGameBoard()
  }
}
