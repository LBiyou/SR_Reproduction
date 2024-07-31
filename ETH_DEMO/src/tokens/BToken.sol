// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// NOTE: The decimal is default 18
contract BToken is ERC20, ERC20Burnable {

    address public treasury;

    constructor(address _treasury) ERC20("BToken", "BT") {
        treasury = _treasury;
    }

    // limit the msg.sender
    modifier onlyTreasury {
        require(msg.sender == treasury);
        _;
    }

    // only the treasury can mint the B Token
    function mint(address to, uint256 amount) public onlyTreasury {
        _mint(to, amount);
    }

    // the hooks function is to execute other operations in _transfer() function
    function _beforeTokenTransfer(address to, uint256 amount) internal {}
    function _afterTokenTransfer(address to, uint256 amount) internal {}
}
