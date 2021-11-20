// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721Tradable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";

/**
 * @title CraftingSet
 * CraftingSet
 */
contract CraftingSet is ERC721Tradable {
  string private _base_token_uri = "ipfs://";

  // Optional mapping for token URIs
  mapping(uint256 => string) private _tokenURISuffixes;

  uint256 public MAX_UNITS;
  modifier saleIsOpen() {
    require(totalSupply() < MAX_UNITS, "Sale end");
    _;
  }

  constructor(
    address _proxyRegistryAddress,
    string memory _name,
    string memory _symbol,
    uint256 _max
  ) ERC721Tradable(_name, _symbol, _proxyRegistryAddress) {
    MAX_UNITS = _max;
  }

  function _setTokenURISuffix(uint256 tokenId, string memory _tokenURISuffix)
    internal
    virtual
  {
    require(_exists(tokenId), "URI set of nonexistent token");
    _tokenURISuffixes[tokenId] = _tokenURISuffix;
  }

  function setBaseURI(string memory _newUri) public virtual {
    _base_token_uri = _newUri;
  }

  function burn(uint256 tokenId) public onlyOwner {
    super._burn(tokenId);

    if (bytes(_tokenURISuffixes[tokenId]).length != 0) {
      delete _tokenURISuffixes[tokenId];
    }
  }

  function mintTo(address _to) public override onlyOwner {
    uint256 newTokenId = _getNextTokenId();
    _mint(_to, newTokenId);
    _incrementTokenId();
  }

  function tokenURI(uint256 _tokenId)
    public
    view
    override
    returns (string memory)
  {
    require(_exists(_tokenId), "URI query for nonexistent token");

    string memory _tokenURISuffix = _tokenURISuffixes[_tokenId];

    if (bytes(_tokenURISuffix).length > 0) {
      return string(abi.encodePacked(_base_token_uri, _tokenURISuffix));
    }
    return _base_token_uri;
    // return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
  }

  function baseTokenURI() public view override returns (string memory) {
    return _base_token_uri;
  }
}
