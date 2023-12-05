import "BlindNinjaCore"
import "BlindNinjaLevel"

pub fun addTypesToArray(_ objects: [AnyStruct]): [{String: AnyStruct}] {
  let results: [{String: AnyStruct}] = []
  for o in objects {
    let cur: {String: AnyStruct} = {
      "type": o.getType(),
      "data": o
    }
    results.append(cur)
  }
  return results
}

pub fun addTypesToGameObjects(_ map: {Int: {BlindNinjaCore.GameObject}}): {Int: AnyStruct} {
  let newMap: {Int: AnyStruct} = {}
  for key in map.keys {
    let nestedObj: {String: AnyStruct} = {}
    nestedObj["type"] = map[key]!.getType()
    nestedObj["data"] = map[key]!
    newMap[key] = nestedObj
  }
  return newMap
}

pub fun addTypeToMap(_ mapObj: {BlindNinjaCore.Map}): {String: AnyStruct} {
  let newMap: {String: AnyStruct} = {
    "data": mapObj,
    "type": mapObj.getType()
  }
  return newMap
}

pub fun main(address: Address, levelName: String): AnyStruct {
    let level: &BlindNinjaLevel = getAccount(address).contracts.borrow<&BlindNinjaLevel>(name: levelName)!
    level.initializeLevel()
    let activeLevel = level.getInitialLevel()

    let mechanics = level.mechanics
    let visuals = level.visuals
    let gameObjects = activeLevel.gameObjects
    let winConditions = level.winConditions

    return {
        "name": level.name,
        "visuals": addTypesToArray(level.visuals),
        "mechanics": addTypesToArray(level.mechanics),
        "winConditions": addTypesToArray(level.winConditions),
        "map": addTypeToMap(activeLevel.map),
        "gameObjects": addTypesToGameObjects(activeLevel.gameObjects)
    }
}