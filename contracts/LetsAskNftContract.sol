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

    string[] bgColors = ["black", "turquoise", "red", "blue", "brown", "green"];
    string[] textColors = [
        "white",
        "linen",
        "azure",
        "bisque",
        "yellow",
        "snow"
    ];

    string svg1 =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: ";
    string svg2 =
        "; font-family: courier new; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svg3 =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    constructor() ERC721("LetsAsk", "LA") {
        console.log("LetsAskNftContract Constructor");
    }

    function mintLetsAskNft(
        string memory questionTo,
        string memory question,
        uint8 textColor,
        uint8 bgColor
    ) public {
        require(bytes(question).length > 0, "Empty question to mint");
        require(bytes(question).length < 281, "More than 280 character length");
        require(bytes(questionTo).length > 0, "Empty To Field");
        require(
            bytes(questionTo).length < 11,
            "More than 10 character length of to field"
        );
        require(textColor < 6, "Wrong text color value. Should be less than 6");
        require(bgColor < 6, "Wrong bgColor value. Should be less than 6");

        uint256 newItemId = _tokenIds.current();
        string memory finalSvg = string(
            abi.encodePacked(
                svg1,
                textColors[textColor],
                svg2,
                bgColors[bgColor],
                svg3,
                "Hello ",
                questionTo,
                ",",
                question,
                "</text></svg>"
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
    }
}
