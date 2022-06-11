// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

contract NFT is ERC721AQueryable, Ownable, ReentrancyGuard {
    using Strings for uint256;

    string private baseTokenURI;
    string private hiddenTokenURI;

    uint256 maxNfts = 10000;

    bool public paused = false;
    bool public revealed = false;

    // constructor
    constructor(string memory _baseTokenUri, string memory _hiddenTokenUri)
        ERC721A("Collection Name", "SYMBOL")
    {
        setBaseTokenURI(_baseTokenUri);
        //_base token uri for the original
        setHiddenURI(_hiddenTokenUri);
        // hidden token uri for unrevealed
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function _mintNfts(address _receiver, uint256 _mintAmount) internal {
        _safeMint(_receiver, _mintAmount);
    }

    function mint(address _receiver, uint256 _mintAmount)
        public
        payable
        nonReentrant
        isPaused
        mintCompliance(_mintAmount)
        onlyOwner
    {
        _mintNfts(_receiver, _mintAmount);
    }

    modifier isPaused() {
        require(!paused, "Contract is paused right now !!");
        _;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(_mintAmount > 0, "You have to mint atleast 1 Nft !!");
        require(
            totalSupply() + _mintAmount <= maxNfts,
            "All Nfts are solded out !!"
        );
        _;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return hiddenTokenURI;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }

    function togglePaused() public onlyOwner {
        paused = !paused;
    }

    function revealNfts() public onlyOwner {
        revealed = true;
    }

    function setBaseTokenURI(string memory _newBaseTokenURI) public onlyOwner {
        baseTokenURI = _newBaseTokenURI;
    }

    function setHiddenURI(string memory _newHiddenTokenUri) public onlyOwner {
        hiddenTokenURI = _newHiddenTokenUri;
    }

    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}
