'use client'

import { useState, useEffect } from 'react'

import { Button, Dialog, Flex, TextField, Code, Text } from '@radix-ui/themes'
import { ExitIcon } from '@radix-ui/react-icons'

import { Magic } from 'magic-sdk'
import { FlowExtension } from '@magic-ext/flow'

const Auth = () => {

    const [inputEmail, setInputEmail] = useState("")
    const [isLoggedIn, setIsLoggedIn] = useState(false)
    const [address, setAddress] = useState("")
    const [loggedInEmail, setLoggedInEmail] = useState("")

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
        if (magic) {
            magic.user.isLoggedIn().then(async (magicIsLoggedIn) => {
                setIsLoggedIn(magicIsLoggedIn)
                if (magicIsLoggedIn) {
                  const { email, publicAddress } = await magic.user.getInfo()
                  setAddress(publicAddress)
                  setLoggedInEmail(email)
                }
              })
        }
    }, [isLoggedIn])

    async function login() {
        await magic.auth.loginWithEmailOTP({ email: inputEmail })
        setIsLoggedIn(true)
    }

    async function logout() {
        if (magic) {
            await magic.user.logout()
            setIsLoggedIn(false)
        }
    }

    if (isLoggedIn) {
        return (
            <Flex gap="4">
                <Flex direction="column">
                    <Text size="2" color="gray">{loggedInEmail}</Text>
                    <Code variant="ghost">{address}</Code>
                </Flex>
                <Flex justify="end" grow="1" align="center">
                    <Button variant="ghost" color="red" onClick={logout}>
                        <ExitIcon width="24" height="24"/>
                    </Button>
                </Flex>
            </Flex>
        )
    } else {
        return (
            <Dialog.Root>
                <Dialog.Trigger>
                    <Button size="2" variant="soft" style={{ cursor: 'pointer' }}>
                        Connect Wallet
                    </Button>
                </Dialog.Trigger>

                <Dialog.Content style={{ maxWidth: 400 }}>
                    <Dialog.Title>Login</Dialog.Title>
                    <Dialog.Description size="2" mb="4">
                        Enter your email to login or create an account.
                    </Dialog.Description>

                    <TextField.Input
                        name="email"
                        width="30"
                        onChange={(e) => setInputEmail(e.target.value)}
                    />

                    <Flex gap="3" mt="4" justify="end">
                        <Dialog.Close style={{ cursor: 'pointer' }}>
                            <Button variant="soft">
                                Cancel
                            </Button>
                        </Dialog.Close>
                        <Dialog.Close style={{ cursor: 'pointer' }}>
                            <Button variant="soft" onClick={login}>
                                Login
                            </Button>
                        </Dialog.Close>
                    </Flex>
                </Dialog.Content>
            </Dialog.Root>
        )
    }
}

export default Auth