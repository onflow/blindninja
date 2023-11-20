echo "Creating a generic level\n"
flow transactions send ./transactions/CreateLevel.cdc myNewLevel --signer emulator-account

echo "\n\nGetting initial board state"
flow scripts execute ./scripts/getInitialBoard.cdc 0xf8d6e0586b0a20c7 myNewLevel

echo "\n\Running basic game"
flow scripts execute ./scripts/ExecuteGame.cdc 0xf8d6e0586b0a20c7 myNewLevel '["ArrowUp","ArrowRight", "ArrowRight", "ArrowRight", "ArrowDown", "ArrowDown"]'

echo "\n\Creating Game with walls mechanic"
flow transactions send ./transactions/CreateLevelWithWalls.cdc WallsLevel --signer emulator-account

echo "\n\Running game with walls mechanic"
flow scripts execute ./scripts/ExecuteGame.cdc 0xf8d6e0586b0a20c7 WallsLevel '["ArrowRight","ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight", "ArrowRight"]'
