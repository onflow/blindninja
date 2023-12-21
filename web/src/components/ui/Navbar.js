import { Flex, Heading, Text, Separator, Badge } from '@radix-ui/themes'

import DarkModeSwitch from '@/components/ui/DarkMode.js'
import Auth from './Auth'

const Navbar = () => {
    return (
        <>
            <Flex p="3" align="center">
                <Flex gap="2" ml="2" align="baseline">
                    <a href='/'>
                        <Heading>🥷 Blind Ninja</Heading>
                    </a>
                    <Text>v0.2.0</Text>
                </Flex>
                <Badge ml="3" variant="surface">Testnet</Badge>
                <Flex mr="2" grow="1" gap="4" justify="end" align="center">
                    <Auth />
                    <DarkModeSwitch />
                </Flex>
            </Flex>

            <Separator size="4"/>
        </>
    )
}

export default Navbar