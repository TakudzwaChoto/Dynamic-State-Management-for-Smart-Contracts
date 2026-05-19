// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/OptimizedPattern.sol";
import "../contracts/BaselineArray.sol";

contract ComprehensiveTest is Test {
    OptimizedPattern public opt;
    BaselineArray public baseline;
    address user = address(0x1234);
    
    function setUp() public {
        opt = new OptimizedPattern();
        baseline = new BaselineArray();
    }
    
    function test_ReportQuality_Success() public {
        vm.prank(user);
        opt.reportQuality(user, 75);
        (uint256[] memory timestamps, ) = opt.getRecentQualityRecords(user);
        assertEq(timestamps.length, 1);
    }
    
    function test_OptimizedVsArray_GasComparison() public {
        uint256 optGas = gasleft();
        opt.reportQuality(user, 75);
        optGas = optGas - gasleft();
        
        uint256 arrGas = gasleft();
        vm.prank(user);
        baseline.reportQuality(user, 75);
        arrGas = arrGas - gasleft();
        
        emit log_named_uint("Optimized gas", optGas);
        emit log_named_uint("Array gas", arrGas);
        assertLt(optGas, arrGas);
    }
    
    function test_MigrateToBackup() public {
        for (uint i = 0; i < 1000; i++) {
            vm.prank(user);
            opt.reportQuality(user, 75);
        }
        vm.warp(block.timestamp + 31 days);
        vm.prank(user);
        opt.migrateToBackup(user);
        (uint256[] memory timestamps, ) = opt.getRecentQualityRecords(user);
        assertEq(timestamps.length, 0);
    }
}
