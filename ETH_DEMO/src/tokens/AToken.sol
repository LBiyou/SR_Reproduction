// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// NOTE: The decimal is default 18
contract AToken is ERC20 {

    address public treasury;

    constructor(address _treasury) ERC20("AToken", "AT") {
        treasury = _treasury;
    }

    // limit the msg.sender
    modifier onlyTreasury {
        require(msg.sender == treasury);
        _;
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    // only the treasury can mint the A Token
    function mint(address to, uint256 amount) public onlyTreasury {
        _mint(to, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }

    // the hooks function is to execute other operations in _transfer() function
    function _beforeTokenTransfer(address to, uint256 amount) internal {}
    function _afterTokenTransfer(address to, uint256 amount) internal {}
}
