from brownie import NFT


def main():
    nft = NFT.at("0x22d276433b3b3566baef76700E7dD054421981Eb")
    NFT.publish_source(nft)
