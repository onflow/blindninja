
pub contract BlindNinjaCore {

  pub struct interface Map {
    pub let anchorX: Int
    pub let anchorY: Int
    pub let viewWidth: Int
    pub let viewHeight: Int
  }

  pub struct interface GameObject {
    pub var id: UInt64
    pub var type: String
    pub var referencePoint: [Int]

    pub fun setReferencePoint(_ newReferencePoint: [Int]) {
      self.referencePoint = newReferencePoint
    }
  }

  pub struct interface GameMechanic {
    
  }

  pub struct interface WinCondition {

  }

  pub struct interface VisualElement {

  }

  // ------------------------------------------
  // Begin GameBoard struct
  // ------------------------------------------
  pub struct GameBoard {
    pub var board: {Int: {Int: [{GameObject}]}}
    pub var newCollisionPoints: [[Int]]

    access(self) fun addToBoard(_ gameObject: {GameObject}) {
      let referencePoint: [Int] = gameObject.referencePoint
      let x = referencePoint[0]!
      let y = referencePoint[1]!

      if (!self.board.containsKey(x)) {
        self.board[x] = {}
      }
      var column = self.board[x]!
      if (column[y] == nil) {
        column[y] = []
      }
      if (column[y]!.length > 0) {
        self.newCollisionPoints.append(referencePoint)
      }
      column[y]!.append(gameObject)
      self.board[x] = column
    }

    access(self) fun clearFromBoard(_ referencePoint: [Int]) {
      let x = referencePoint[0]!
      let y = referencePoint[1]!
      var column = self.board[x]!
      column[y] = []
      self.board[x] = column
    }

    // Add the given gameobject to the gameboard
    pub fun add(_ gameObject: {GameObject}?) {
      if (gameObject != nil) {
        self.addToBoard(gameObject!)
      }
    }

    // Remove this object from the gameboard
    pub fun remove(_ gameObject: {GameObject}?) {
      if (gameObject != nil) {
        self.clearFromBoard(gameObject!.referencePoint)
      }
    }

    pub fun clearCollisionPoints() {
      self.newCollisionPoints = []
    }

    init() {
      self.board = {}
      self.newCollisionPoints = []
    }
  }

  pub struct ActiveLevel {
    pub let map: {Map}
    pub let gameObjects: {Int: {GameObject}}
    pub let gameboard: GameBoard
    pub let hasWonGame: Bool

    init(map: {Map}, gameObjects: {Int: {GameObject}}, gameboard: GameBoard, hasWonGame: Bool) {
      self.map = map
      self.gameObjects = gameObjects
      self.gameboard = gameboard
      self.hasWonGame = hasWonGame
    }
  }

  // ------------------------------------------
  // Begin Level interface
  // ------------------------------------------
  pub resource interface Level {
    access(all) let name: String

    // The map and gameobjects can and likely will change during
    //  a game to represent changes in view or gameobject,
    // so when a game starts they are copied to a new
    // struct for the 'ActiveLevel'
    access(all) let map: {Map}
    access(all) let gameObjects: {Int: {GameObject}}

    // ------ Static modifiers that control the level --------
    // the below are static objects, and not included in an 'activelevel'

    // Mechanics are run on every tick, according to the type of mechanic.
    //  i.e. a collision mechanic will be run whenever a collision occurs between
    //       2 game objects.
    // TODO: Determine all type of mechanics, and plug them in appropriately.
    access(all) let mechanics: [{GameMechanic}]

    // Win conditions decide how a game could be won.
    // The game's tick will always check if the win conditions are satisfied
    // on each iteration.
    access(all) let winConditions: [{WinCondition}]

    // Static visuals that do not tick, and are in the background of the game.
    // This also can be used to associate an ID to a visual element for it.
    // This allows you to decouple the gameobjects from their visual counterpart.
    access(all) let visuals: [{VisualElement}]

    access(all) let gameboard: GameBoard

    // ------ End Static modifiers --------

    // ------ Game Execution --------
    access(all) fun getInitialLevel(): ActiveLevel {
      let activeLevel = BlindNinjaCore.ActiveLevel(
        map: self.map,
        gameObjects: self.gameObjects,
        gameboard: self.gameboard,
        hasWonGame: false
      )
      return activeLevel
    }

    access(all) fun executeLevel(sequence: [String]): [ActiveLevel] {
      var results: [ActiveLevel] = []
      results.append(self.getInitialLevel())
      var i: Int = 0
      var hasWon = false
      var lastResult = results[0]!
      while (i < sequence.length) {
        hasWon = hasWon || self.tickLevel(curSequence: sequence[i])
        let levelResults: ActiveLevel = ActiveLevel(
          map: self.map,
          gameObjects: self.gameObjects,
          gameboard: self.gameboard,
          hasWonGame: hasWon
        )
        results.append(levelResults)
        i = i + 1
      }
      return results
    }

    // Returns true if the game has been won.
    access(all) fun tickLevel(curSequence: String): Bool
    // ------ End Game Execution -------
  
  }

  // ------------------------------------------
  // End Level interface
  // ------------------------------------------

  // ------------------------------------------
  // Start level collection
  // ------------------------------------------

  pub resource interface LevelCollectionPublic {
    pub fun getLevel(_ name: String): &{Level}
    pub fun getLevelNames(): [String]
  }

  pub resource LevelCollection: LevelCollectionPublic {
    pub var levels: @{String: {Level}}

    init() {
      self.levels <- {}
    }

    destroy() {
      destroy self.levels
    }

    pub fun addLevel(_ level: @{Level}) {
      let prev <- self.levels[level.name] <- level
      destroy prev
    }

    pub fun getLevel(_ name: String): &{Level} {
      return (&self.levels[name] as &{Level}?)!
    }

    pub fun removeLevel(_ name: String): @{Level}? {
      let level <- self.levels.remove(key: name)
      return <-level
    }

    pub fun getLevelNames(): [String] {
      return self.levels.keys
    }
  }

  pub fun createLevelCollection(): @LevelCollection {
    return <- create LevelCollection()
  }

  // ------------------------------------------
  // End level collection
  // ------------------------------------------
}

