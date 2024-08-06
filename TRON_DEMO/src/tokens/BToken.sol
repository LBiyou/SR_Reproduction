// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts@4.8.3/token/ERC20/ERC20.sol";


// NOTE: The decimal is default 18
contract BToken is ERC20 {

    address public treasury;

    constructor(address _treasury) ERC20("BToken", "BT") {
        treasury = _treasury;
    }

    // limit the msg.sender
    modifier onlyTreasury {
        require(msg.sender == treasury, "You are not the treasury.");
        _;
    }

    // only the treasury can mint the B Token
    function mint(address to, uint256 amount) onlyTreasury public {
        _mint(to, amount);
    }

    function burn(address account, uint256 amount) onlyTreasury public {
        _burn(account, amount);
    }

    // the hooks function is to execute other operations in _transfer() function
    function _beforeTokenTransfer(address to, uint256 amount) internal {}
    function _afterTokenTransfer(address to, uint256 amount) internal {}
}
