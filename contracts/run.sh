echo "RUNNING TX\n"
flow transactions send ./transactions/CreateLevel.cdc myNewLevel --signer emulator-account

echo "\n\nGETTING INTIAL BOARD"
flow scripts execute ./scripts/getInitialBoard.cdc 0xf8d6e0586b0a20c7 myNewLevel

echo "\n\nRUNNING WHOLE GAME"
flow scripts execute ./scripts/ExecuteGame.cdc 0xf8d6e0586b0a20c7 myNewLevel '["ArrowUp","ArrowRight"]'