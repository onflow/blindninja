import { Flex, Heading, Text, Separator } from '@radix-ui/themes'

import DarkModeSwitch from '@/components/ui/DarkMode.js'

const Navbar = () => {
    return (
        <>
            <Flex p="2" align="center">
                <Flex gap="2" ml="2" align="baseline">
                    <a href='/'>
                        <Heading>🥷 Blind Ninja</Heading>
                    </a>
                    <Text>v0.0.1</Text>
                </Flex>
                <Flex mr="2" grow="1" justify="end">
                    <DarkModeSwitch />
                </Flex>
            </Flex>

            <Separator size="4"/>
        </>
    )
}

export default Navbar