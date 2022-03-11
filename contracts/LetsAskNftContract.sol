//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import "base64-sol/base64.sol";

contract LetsAskNftContract is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event LetsAskNftMinted(address sender, uint256 tokenId);


    string svg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='black' /> <foreignObject x='0' y='0' width='100%' height='100%'> <body xmlns='http://www.w3.org/1999/xhtml'> <div style=' font-size: 20px; position: absolute; top: 50%; left: 50%; -ms-transform: translateX(-50%) translateY(-50%); -webkit-transform: translate(-50%, -50%); transform: translate(-50%, -50%);'> <p id='text' style='text-align: center; vertical-align: middle; background: -webkit-linear-gradient(left, #FC5C7D, #6A82FB); background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent;'>";
     string svg2 ="</p></div></body></foreignObject></svg>";

    constructor() ERC721("LetsAsk", "LA") {
        console.log("LetsAskNftContract Constructor");
    }

    function mintLetsAskNft(
        string memory questionTo,
        string memory question
    ) public {
        require(bytes(question).length > 0, "Empty question to mint");
        require(bytes(question).length < 281, "More than 280 character length");
        require(bytes(questionTo).length > 0, "Empty To Field");
        require(
            bytes(questionTo).length < 11,
            "More than 10 character length of to field"
        );

        uint256 newItemId = _tokenIds.current();
        string memory finalSvg = string(
            abi.encodePacked(
                svg1,
                "Hello ",
                questionTo,
                ", ",
                question,
                svg2
               
            )
        );

       

        string memory qTo = string(
            abi.encodePacked("Q#", Strings.toString(newItemId), " - ", questionTo)
        );

        string memory finalJson = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        qTo,
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

         console.log(finalTokenUri);

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();
        console.log("LetsAsk NFT minted", newItemId, msg.sender);
        emit LetsAskNftMinted(msg.sender, newItemId);
    }
}
