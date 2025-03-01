// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IERC1404 } from '../../../interfaces/IERC1404.sol';
import { ERC20BaseInternal } from '../../ERC20/base/ERC20BaseInternal.sol';
import { IERC1404BaseInternal } from './IERC1404BaseInternal.sol';
import { ERC1404BaseStorage } from './ERC1404BaseStorage.sol';

/**
 * @title Base ERC1404 internal functions
 */
abstract contract ERC1404BaseInternal is
    IERC1404BaseInternal,
    ERC20BaseInternal
{
    /**
     * @notice define restriction codes and their associated messages
     * @param restrictionCodes list of restriction codes whose messages to set
     * @param restrictionMessages list of restriction messages
     */
    function _setRestrictions(
        uint8[] memory restrictionCodes,
        string[] memory restrictionMessages
    ) internal {
        if (restrictionCodes.length != restrictionMessages.length)
            revert ERC1404Base__ArrayLengthMismatch();

        mapping(uint8 => string) storage restrictions = ERC1404BaseStorage
            .layout()
            .restrictions;

        unchecked {
            for (uint256 i; i < restrictionCodes.length; i++) {
                restrictions[restrictionCodes[i]] = restrictionMessages[i];
            }
        }
    }

    /**
     * @notice query the restriction code for a proposed transfer
     * @param from owner of tokens to be transferred
     * @param to beneficiary of transfer
     * @param amount quantity of tokens transferred
     * @return restrictionCode restriction code for transfer (0 if no restriction exists)
     */
    function _detectTransferRestriction(
        address from,
        address to,
        uint256 amount
    ) internal view virtual returns (uint8 restrictionCode);

    /**
     * @notice query the restriction message for a given restriction code
     * @param restrictionCode restriction code whose message to query
     * @return message restriction message
     */
    function _messageForTransferRestriction(
        uint8 restrictionCode
    ) internal view virtual returns (string memory message) {
        message = ERC1404BaseStorage.layout().restrictions[restrictionCode];
    }

    /**
     * @notice ERC20 hook: detect and handle transfer restriction
     * @inheritdoc ERC20BaseInternal
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        uint8 restrictionCode = _detectTransferRestriction(from, to, amount);

        if (restrictionCode != 0) {
            revert(_messageForTransferRestriction(restrictionCode));
        }
    }
}
