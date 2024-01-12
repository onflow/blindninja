import "BlindNinjaCore"

access(all) contract interface BlindNinjaMechanic {
  access(all) struct interface Mechanic: BlindNinjaCore.GameMechanic {}
}
