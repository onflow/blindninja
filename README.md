# BlindNinja

Welcome to BlindNinja, an innovative blockchain-based game that challenges players to navigate a ninja through various missions built with on-chain logic. BlindNinja allows for edits to the mechanics, visuals, and map designs of all levels, and allows both the edits and the sharing of these modifications in the same UI.

BlindNinja is playable and remixable at https://blindninja.vercel.app

## Table of Contents

- [About BlindNinja](#about-blindninja)
- [Game Features](#game-features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Smart Contracts](#smart-contracts)
- [Web Interface](#web-interface)
- [Contributing](#contributing)
- [License](#license)

## About BlindNinja

BlindNinja is a fully on-chain game that leverages the Flow blockchain to create a decentralized gaming experience. Players input moves for their ninja, which are then executed on-chain to determine the outcome based on the game's logic and state. All elements of the game aside from the front-end are controlled fully by on-chain logic. This includes the visuals, the game mechanics, the actual move impelementations, win conditions, and more.

## Game Features

- **Transparent Moves**: Every move is executed on the Flow Blockchain, ensuring full transparency.
- **Provable Outcomes**: The state and outcome of each game can be independently verified on the blockchain.
- **Community-Driven Development**: Anyone can contribute to the game's development by remixing or modifying the on-chain contracts.
- **Dynamic Gameplay**: New levels and challenges can be introduced by anyone on-chain via Smart Contracts, providing endless replayability.

## Tech Stack

- Flow Blockchain: Cadence smart contracts for game logic
- Frontend: Next.js for the web interface
- Styling: Radix for responsive design

## Getting Started

To get started with BlindNinja, clone the repository and follow these steps:

1. Install dependencies: `npm install`
2. Compile smart contracts: `<compilation_instructions>`
3. Deploy contracts: `<deployment_instructions>`
4. Start the web interface: `npm run dev`

## Smart Contracts

The `contracts` directory contains all the Solidity smart contracts used to manage the game's logic.

- **Contracts**: Core game logic
- **Scripts**: Deployment and interaction scripts
- **Transactions**: On-chain transactions

## Web Interface

The `web` directory holds the Next.js project for the user interface.

- **.next**: The build output for Next.js.
- **src**: Source files for the frontend application.

## How to Make Modifications to the Game via Smart Contracts

BlindNinja is designed to be a highly customizable and extendable game. Players and developers can modify the game by creating new levels, game objects, mechanics, and win conditions, all through Cadence smart contracts on the Flow blockchain. 

You can make modifications to the smart contracts of a level you are playing directly in the UI using the 'remix' feature while on the game screen of a current level

Alternatively, you make your own smart contract deployments outside of the game by interacting with the Flow Blockchain directly.

### Understanding the Interfaces

To assist you in making modifications, you should understand the interfaces that all game elements implement. Here are the key interfaces:

- **BlindNinjaLevel**: This defines the structure of a level, including the map, game objects, mechanics, win conditions, and visuals.
- **GameObject**: Game objects within the environment that players interact with, like obstacles or items.
- **GameMechanic**: Mechanics that can affect the game state on every tick.
- **WinCondition**: Conditions that define how a game can be won.

All of the above have examples labeled within the 'contracts/contracts' which can be used to help you with the implementation for your game. You also can mix and match and use mechanics, objects, win conditions developed by others within your custom level.

### Sharing Your Creations

After you've created and tested your new game elements, share them with the BlindNinja community. After your level implementation is deployed on testnet, you may access it by modifying your url like the following:

https://blindninja.vercel-app.com/:Address/:ContractName

i.e.
https://blindninja.vercel.app/0x5a2170a24ca5da66/FogLevel


## Contributing

We welcome contributions from the community. Please read our contributing guidelines and submit your pull requests or open an issue to discuss your ideas.

## License

BlindNinja is open source and distributed under the [LICENSE](LICENSE) found in the repository.

---

For more information, please refer to the individual README.md files within each directory.
