# contracts folder
## Testing
### To run locally

1. Open a terminal and run the flow emulator.
2. Open another terminal tab and run 'flow dev' to deploy the contracts.
3. Open another terminal and run './run.sh' with `sh run.sh`
    This will create a new level, and run a level given some arguments. The arguments can be modified in run.sh directly or copied out to your own terminal setup.

### To use testnet

1. Grab the testnet address from flow.json
2. Create a level using the 'ComposableLevel', example present in './transactions/CreateLevel'
3. From front-end or CLI, get the initial board data with the './scripts/GetInitialBoard.cdc' script, which is a preview of the level that can be shown, and details of all aspects/mechanics within the level, and how it is intended to be visualized.
4. From front-end or CLI, execute the game using the './scripts/ExecuteGame.cdc' script, providing the moves for the ninja as well as an argument.

## Deployment
Key is to be added to 1pass soon. Currently in Amit's setup.

To deploy to testnet:
`flow project deploy -n testnet`
