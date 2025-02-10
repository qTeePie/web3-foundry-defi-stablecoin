// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

/**
 *  Finding invariants in a code-base is about identifying the core rules that must always be true.
 *
 * Invariants are things that should never change or break in your smart contract in order for it to be regarded as "proper-functioning".
 * A bug isn't inherently causing a non-functioning contract, it may only cause minor inconveniences.
 *
 *     Steps to uncover code invariants:
 *     1️⃣ Ask: "What must always be true in my contract?"
 *     2️⃣ Check state variables (invariants often involve totalSupply, balances, collateral, etc.)
 *     3️⃣ Analyze functions (does any function break key properties?)
 *     4️⃣ Think like a hacker (where could things go wrong?)
 *     5️⃣ Write invariant tests to enforce these rules.
 *
 * For our stablecoin contract, invariants incluude:
 *  🐱‍🏍 TotalSupply must never exceed collateral.
 *  🐱‍👤 Balances[msg.sender] should never be negative.
 *  🐱‍💻 Getter view functions should never revert.
 */
contract InvariantsTest is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,, weth, wbtc,) = config.activeNetworkConfig();
        // Setting address of our DSCEngine contract (to be called during fuzz-testing)
        targetContract(address(dsce));
    }

    /**
     * Test that our invariant: value of DSC tokens minted never succeed collateral value
     */
    function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethValue = dsce.getUsdValue(weth, totalWethDeposited);
        uint256 wbtcValue = dsce.getUsdValue(wbtc, totalWbtcDeposited);
    }
}
