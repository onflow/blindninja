import { useRef, useState, useEffect } from 'react'
import { useTheme } from 'next-themes'

import * as fcl from "@onflow/fcl"
import { Magic } from "magic-sdk"
import { FlowExtension } from '@magic-ext/flow'

import { Flex, Box, Button, Callout, Dialog, Badge, Text } from '@radix-ui/themes'

import { FileIcon, FileTextIcon } from '@radix-ui/react-icons'

import Editor from '@monaco-editor/react'

const Remix = ({ gameDetails, contracts }) => {

    const editorRef = useRef(null)

    const { resolvedTheme } = useTheme()
    const isDarkMode = resolvedTheme && resolvedTheme === 'dark'

    let keys = [
        {
            key: 'level',
            label: 'Level',
        },
        {
            key: 'gameObjects',
            label: 'Game Objects',
        },
        {
            key: 'mechanics',
            label: 'Mechanics',
        },
        // {
        //     key: 'visuals',
        //     label: 'Art',
        // },
        {
            key: 'winConditions',
            label: 'Win Conditions',
        }
    ]

    const [updatedContracts, setUpdatedContracts] = useState({
        level: {},
        others: [],
    })
    const [updatedContractsCount, setUpdatedContractsCount] = useState(0)
    const [deploying, setDeploying] = useState(false)

    let levelAddress = ''
    let levelContract = ''
    if (gameDetails.level && gameDetails.level.length > 0) {
        levelAddress = gameDetails.level[0].type.typeID.split('.')[1]
        levelContract = gameDetails.level[0].type.typeID.split('.')[2]
    }

    let magic = null

    if (typeof window !== 'undefined') {
        magic = new Magic('pk_live_4BD334B5102E41A9', {
            extensions: [
                new FlowExtension({
                // testnet or mainnet to connect different network
                rpcUrl: 'https://rest-testnet.onflow.org',
                network: 'testnet'
                }),
            ],
        })
    }

    useEffect(() => {
        setUpdatedContractsCount(calculateUpdateCount())
    }, [updatedContracts])

    function calculateUpdateCount() {
        let count = 0
        if (updatedContracts.level.code) {
            count += 1
        }
        count += updatedContracts.others.length
        return count
    }

    function updateCode(address, name) {

        if (contracts[address][name] !== editorRef.current.getValue()) {

            // non-level contract update
            if(address !== levelAddress || name !== levelContract) {

                let originalImport = `import ${name} from 0x${address}`
                let newImport = `import ${name} from 0x_USER_ADDRESS`

                let levelCode = ''
                if (updatedContracts.level.code) {
                    levelCode = updatedContracts.level.code
                } else {
                    levelCode = contracts[levelAddress][levelContract]
                }
                let newLevelCode = levelCode.replace(originalImport, newImport)

                setUpdatedContracts((prevData) => {
                    let others = [...prevData.others]
                    let i = others.findIndex(x => x.address === address && x.name === name)
                    if (i > -1) {
                        others[i].code = editorRef.current.getValue()
                    } else {
                        others.push({
                            address: address,
                            name: name,
                            code: editorRef.current.getValue()
                        })
                    }

                    return {
                        level: {
                            code: newLevelCode
                        },
                        others: others,
                    }
                })
            } else {
                // level contract update
                setUpdatedContracts((prevData) => {
                    return {
                        level: {
                            code: editorRef.current.getValue()
                        },
                        others: prevData.others
                    }
                })
            }
        } else {
            // non-level contract revert
            if(address !== levelAddress || name !== levelContract) {
                setUpdatedContracts((prevData) => {
                    let c = prevData.others.filter(x => x.address !== address || x.name !== name)
                    if (!c) {
                        c = []
                    }
                    let level = prevData.level
                    if (level) {
                        let originalImport = `import ${name} from 0x_USER_ADDRESS`
                        let newImport = `import ${name} from 0x${address}`

                        level.code = level.code.replace(originalImport, newImport)

                        if (level.code === contracts[levelAddress][levelContract]) {
                            level = {}
                        }
                    }
                    return {
                        level: level,
                        others: c,
                    }
                })
            } else {
                // level contract revert
                setUpdatedContracts((prevData) => {
                    return {
                        level: {},
                        others: [],
                    }
                })
            }
        }
    }

    function getContractName(code) {
        const regex = /(pub|access\(all\)) contract (\w+)/
        const match = code.match(regex)

        if (match) {
            return match[2]
        } else {
            return null
        }
    }

    async function deploy() {
        // this fails on cadence if multiple contracts depend on each other
        setDeploying(true)
        const { publicAddress } = await magic.user.getInfo()
        let deployContracts = []
        let levelContractName = ''
        for (const c of updatedContracts.others) {
            deployContracts.push({
                key: getContractName(c.code),
                value: c.code.replace('0x_USER_ADDRESS', publicAddress),
            })
        }
        if (updatedContracts.level.code) {
            levelContractName = getContractName(updatedContracts.level.code)
            deployContracts.push({
                key: levelContractName,
                value: updatedContracts.level.code.replace('0x_USER_ADDRESS', publicAddress)
            })
        }
        console.log('deploying', deployContracts)
        let txId = await fcl.mutate({
            cadence: `transaction (contracts: {String: String}) {
                prepare(user: AuthAccount){
                    for contract in contracts.keys {
                        user.contracts.add(name: contract, code: contracts[contract]!.utf8)
                    }
                }
            }`,
            proposer: magic.flow.authorization,
            payer: magic.flow.authorization,
            authorizations: [magic.flow.authorization],
            limit: 9999,
            args: (arg, t) => [
                arg(deployContracts, t.Dictionary({key: t.String, value: t.String}))
            ]
        })
        console.log('transaction sent', txId)
        let tx = await fcl.tx(txId).onceSealed()
        console.log('transaction sealed', tx)
        setDeploying(false)
        window.location.href = `/${publicAddress}/${levelContractName}`
    }

    async function deployMultiple() {
        setDeploying(true)
        const { publicAddress } = await magic.user.getInfo()
        // deploy others
        let deployContracts = []
        for (const c of updatedContracts.others) {
            deployContracts.push({
                key: getContractName(c.code),
                value: c.code.replace('0x_USER_ADDRESS', publicAddress),
            })
        }
        if (deployContracts.length > 0) {
            console.log('deploying others', deployContracts)
            let txId = await fcl.mutate({
                cadence: `transaction (contracts: {String: String}) {
                    prepare(user: AuthAccount){
                        for contract in contracts.keys {
                            user.contracts.add(name: contract, code: contracts[contract]!.utf8)
                        }
                    }
                }`,
                proposer: magic.flow.authorization,
                payer: magic.flow.authorization,
                authorizations: [magic.flow.authorization],
                limit: 9999,
                args: (arg, t) => [
                    arg(deployContracts, t.Dictionary({key: t.String, value: t.String}))
                ]
            })
            console.log('transaction sent', txId)
            let tx = await fcl.tx(txId).onceSealed()
            console.log('transaction sealed', tx)
        }
        // deploy level
        let levelContractName = ''
        if (updatedContracts.level.code) {
            levelContractName = getContractName(updatedContracts.level.code)
            let levelContractCode = updatedContracts.level.code.replace('0x_USER_ADDRESS', publicAddress)
            let txId = await fcl.mutate({
                cadence: `transaction (name: String, code: String) {
                    prepare(user: AuthAccount){
                        user.contracts.add(name: name, code: code.utf8)
                    }
                }`,
                proposer: magic.flow.authorization,
                payer: magic.flow.authorization,
                authorizations: [magic.flow.authorization],
                limit: 9999,
                args: (arg, t) => [
                    arg(levelContractName, t.String),
                    arg(levelContractCode, t.String),
                ]
            })
            console.log('level deployment transaction sent', txId)
            let tx = await fcl.tx(txId).onceSealed()
            console.log('level deployment transaction sealed', tx)
        }
        setDeploying(false)
        if (updatedContracts.level.code) {
            window.location.href = `/${publicAddress}/${levelContractName}`
        }
    }

    function handleEditorDidMount(editor, monaco) {
        editorRef.current = editor
    }

    return (
        <Flex direction="column">
            {updatedContractsCount > 0 &&
                <Callout.Root mb="5">
                    {/* <Callout.Icon>
                        <InfoCircledIcon />
                    </Callout.Icon> */}
                    <Callout.Text>
                        <Flex direction="column" gap="3">
                            {updatedContractsCount} contract{updatedContractsCount > 1 && <>s</>} ready to be deployed!
                            <Button onClick={deployMultiple} disabled={deploying}>
                                {deploying ? 'Deploying...' : 'Deploy'}
                            </Button>
                        </Flex>
                    </Callout.Text>
                </Callout.Root>
            }
            {keys.map((key) => (
                <Box mb="5" key={key.key}>
                    <Box>
                        <Text>
                            {key.label}
                        </Text>
                    </Box>

                    <Box
                        mt="2"
                        style={{
                            borderLeftWidth: 1,
                            borderStyle: 'solid',
                            borderColor: 'var(--gray-a7)',
                        }}
                    >
                        <Flex direction="column">
                            {gameDetails[key.key]
                             && Object.keys(gameDetails[key.key]).filter((index) => {
                                // make unique
                                return Object.keys(gameDetails[key.key]).find(x => gameDetails[key.key][x].data.name === gameDetails[key.key][index].data.name) == index
                            }).map((index) => {

                                let address = gameDetails[key.key][index].type.typeID.split('.')[1]
                                let name = gameDetails[key.key][index].type.typeID.split('.')[2]

                                return (
                                <Flex mx="3" my="2" align="center" key={index}>
                                    <Dialog.Root>

                                        <Flex align="center" grow="1">
                                            <Flex ml="1">
                                                <Dialog.Trigger style={{ cursor: 'pointer' }}>
                                                    <Button variant="ghost">
                                                        <FileIcon width="16" height="16"/>
                                                        {gameDetails[key.key][index].data.name}
                                                    </Button>
                                                </Dialog.Trigger>
                                            </Flex>
                                            <Flex grow="1" justify="end">
                                                { ((key.key === 'level' && updatedContracts.level.code) ||
                                                    updatedContracts.others.findIndex(x => x.address == address && x.name == name) > -1) &&
                                                    <Badge mr="0" size="1" variant="outline" color="orange">
                                                        U
                                                    </Badge>
                                                }
                                            </Flex>
                                        </Flex>

                                        <Dialog.Content style={{ maxWidth: 800 }}>
                                            <Dialog.Title>{gameDetails[key.key][index].type.typeID}</Dialog.Title>
                                            <Dialog.Description size="2" mb="4">
                                                Make code changes.
                                            </Dialog.Description>

                                            <Editor
                                                height="50vh"
                                                language="swift"
                                                theme={isDarkMode ? "vs-dark" : "light"}
                                                value={
                                                    key.key === 'level' && updatedContracts.level.code
                                                    ?
                                                    updatedContracts.level.code
                                                    :
                                                        updatedContracts.others.findIndex(x => x.address == address && x.name == name) > -1
                                                        ?
                                                        updatedContracts.others.find(x => x.address == address && x.name == name).code
                                                        :
                                                        (contracts ? contracts[address][name] : '')
                                                }
                                                onMount={handleEditorDidMount}
                                            />

                                            <Flex gap="3" mt="4" justify="end">
                                                <Dialog.Close style={{ cursor: 'pointer' }}>
                                                    <Button variant="soft">
                                                        Cancel
                                                    </Button>
                                                </Dialog.Close>
                                                <Dialog.Close style={{ cursor: 'pointer' }}>
                                                    <Button variant="soft" onClick={() => updateCode(address, name)}>
                                                        Confirm
                                                    </Button>
                                                </Dialog.Close>
                                            </Flex>
                                        </Dialog.Content>
                                    </Dialog.Root>
                                </Flex>
                            )})}
                        </Flex>
                    </Box>
                </Box>
            ))}
      </Flex>
    )
}

export default Remix