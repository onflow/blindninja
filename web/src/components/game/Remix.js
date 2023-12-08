import { useRef, useState } from 'react'
import { useTheme } from 'next-themes'

import { Flex, Box, Button, Callout, Dialog, Badge, Text } from '@radix-ui/themes'

import { FileIcon, FileTextIcon } from '@radix-ui/react-icons'

import Editor from '@monaco-editor/react'

const Remix = ({ gameDetails, contracts }) => {

    const editorRef = useRef(null)

    const { resolvedTheme } = useTheme()
    const isDarkMode = resolvedTheme && resolvedTheme === 'dark'

    let keys = [
        // {
        //     key: 'map',
        //     label: 'Map',
        // },
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

    const [updatedContracts, setUpdatedContracts] = useState({})
    const [updatedContractsCount, setUpdatedContractsCount] = useState(0)

    function updateCode(address, name) {
        if (contracts[address][name] !== editorRef.current.getValue()) {
            setUpdatedContracts({
                ...updatedContracts,
                [address]: {
                    ...updatedContracts[address],
                    [name]: editorRef.current.getValue()
                }
            })
            setUpdatedContractsCount(updatedContractsCount + 1)
        } else {
            if (updatedContracts[address] && updatedContracts[address][name]) {
                setUpdatedContracts((prevData) => {
                    const newData = {...prevData}
                    delete newData[address][name]
                    return newData
                })
                setUpdatedContractsCount(updatedContractsCount - 1)
            }
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
                            <Button>Deploy</Button>
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
                                                {updatedContracts[address] && updatedContracts[address][name] &&
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
                                                    updatedContracts[address] && updatedContracts[address][name]
                                                    ?
                                                    updatedContracts[address][name]
                                                    :
                                                    (contracts ? contracts[address][name] : '')
                                                }
                                                // value={contracts ? contracts[address][name] : ''}
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