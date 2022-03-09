//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import 'base64-sol/base64.sol';

contract LetsAskNftContract is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    constructor() ERC721("LetsAsk", "LA") {
        console.log("LetsAskNftContract Constructor");
    }

    function mintLetsAskNft(string memory to, string memory data) public {
        
        require(bytes(data).length > 0, "Empty question to mint");
        require(bytes(data).length > 280, "More than 280 character length");
        require(bytes(to).length > 0, "Empty To Field");
        require(bytes(to).length > 10, "More than 10 character length of to field");


        uint256 newItemId = _tokenIds.current();
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, data, "</text></svg>")
        );

        string memory questionTo = string(
            abi.encodePacked("Question #", newItemId, "-", to)
        );

        string memory finalJson = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        questionTo,
                        '", "description": "Lets Ask - Question the status Quo", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", finalJson)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();
        console.log("LetsAsk NFT minted", newItemId, msg.sender);
    }
}
