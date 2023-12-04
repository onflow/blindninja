echo "\n\nGetting initial board state"
flow scripts execute ./scripts/getInitialBoard.cdc 0x01cf0e2f2f715450 IntroLevel

echo "\n\Running basic game"
flow scripts execute ./scripts/ExecuteGame.cdc 0x01cf0e2f2f715450 IntroLevel '["ArrowUp","ArrowRight", "ArrowRight", "ArrowRight", "ArrowDown", "ArrowDown"]'

echo "\n\Running game with walls mechanic"
flow scripts execute ./scripts/ExecuteGame.cdc 0x01cf0e2f2f715450 WallsLevel '["ArrowRight","ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight"]'

echo "\n\Running game with fog mechanic"
flow scripts execute ./scripts/ExecuteGame.cdc 0x01cf0e2f2f715450 FogLevel '["ArrowRight","ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight"]'
