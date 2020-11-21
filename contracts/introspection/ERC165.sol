// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import '@openzeppelin/contracts/introspection/IERC165.sol';

import './LibERC165.sol';

abstract contract ERC165 is IERC165 {
  function supportsInterface (bytes4 interfaceId) override public view returns (bool) {
    return LibERC165.layout().supportedInterfaces[interfaceId];
  }
}