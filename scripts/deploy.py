from scripts.helpful_scripts import get_account
from brownie import NFT, config, network


def deploy_nft():
    account = get_account()

    publish_source = config["networks"][network.show_active()]["verify"]

    print('deploying NFT contract ...')
    nft = NFT.deploy(
        'https://gateway.pinata.cloud/ipfs/Qma4UxBgWeh7SbMSEqGCssbWHhtQA3PR3GGGFGSm3czRyW/',
        'https://gateway.pinata.cloud/ipfs/QmcbaaNZrFKM9v2jqy3ddJwcGe2kThpF5T8NHdgqPbpM1c',
        {"from": account},
        publish_source=publish_source
    )

    print(f'nft is deployed at {nft.address}')


def main():
    deploy_nft()
