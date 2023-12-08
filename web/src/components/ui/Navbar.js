import { Flex, Heading, Text, Separator, Badge } from '@radix-ui/themes'

import DarkModeSwitch from '@/components/ui/DarkMode.js'

const Navbar = () => {
    return (
        <>
            <Flex p="2" align="center">
                <Flex gap="2" ml="2" align="baseline">
                    <a href='/'>
                        <Heading>🥷 Blind Ninja</Heading>
                    </a>
                    <Text>v0.1.0</Text>
                </Flex>
                <Badge ml="3" variant="surface">Testnet</Badge>
                <Flex mr="2" grow="1" justify="end">
                    <DarkModeSwitch />
                </Flex>
            </Flex>

            <Separator size="4"/>
        </>
    )
}

export default Navbar