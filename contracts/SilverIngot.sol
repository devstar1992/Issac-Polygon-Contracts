// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";

contract SilverIngot is ERC20, AccessControl {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

  constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    // Grant the minter role to a specified account
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }


  function decimals() public view virtual override returns (uint8) {
    return 0;
  }

  function mint(address account, uint256 amount) public onlyRole(MINTER_ROLE){
      _mint(account, amount);
  }

  function burn(address account, uint256 amount) public onlyRole(BURNER_ROLE){
      _burn(account, amount);
  }
}
