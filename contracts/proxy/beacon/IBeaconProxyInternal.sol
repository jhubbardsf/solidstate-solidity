// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { IProxyInternal } from '../IProxyInternal.sol';

interface IBeaconProxyInternal is IProxyInternal {
    error BeaconProxy__FetchImplementationFailed();
}
