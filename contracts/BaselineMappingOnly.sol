// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaselineMappingOnly {
    mapping(address => mapping(uint256 => int256)) public records;
    mapping(address => uint256[]) public timestamps;

    event QualityReported(address indexed user, uint256 timestamp);

    function reportQuality(address user, int256 qualityLevel) public {
        require(qualityLevel >= 0 && qualityLevel <= 100, "Invalid quality level");
        uint256 timestamp = block.timestamp;
        records[user][timestamp] = qualityLevel;
        timestamps[user].push(timestamp);
        emit QualityReported(user, timestamp);
    }

    function getRecentQualityRecords(address user) public view returns (uint256[] memory, int256[] memory) {
        uint256[] storage tsList = timestamps[user];
        int256[] memory levels = new int256[](tsList.length);
        for (uint256 i = 0; i < tsList.length; i++) {
            levels[i] = records[user][tsList[i]];
        }
        return (tsList, levels);
    }

    function getRecordCount(address user) public view returns (uint256) {
        return timestamps[user].length;
    }
}
