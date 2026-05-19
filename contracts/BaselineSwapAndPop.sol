// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaselineSwapAndPop {
    struct Event { uint256 timestamp; int256 quality; }
    mapping(address => Event[]) public records;
    mapping(address => Event[]) public historicalData;

    event QualityReported(address indexed user, uint256 timestamp);

    function reportQuality(address user, int256 qualityLevel) public {
        require(qualityLevel >= 0 && qualityLevel <= 100, "Invalid quality level");
        records[user].push(Event(block.timestamp, qualityLevel));
        emit QualityReported(user, block.timestamp);
    }

    function getRecentQualityRecords(address user) public view returns (Event[] memory) {
        return records[user];
    }

    function migrateToHistorical(address user, uint256 beforeTimestamp) public {
        Event[] storage events = records[user];
        uint256 i = 0;
        while (i < events.length) {
            if (events[i].timestamp < beforeTimestamp) {
                historicalData[user].push(events[i]);
                events[i] = events[events.length - 1];
                events.pop();
            } else {
                i++;
            }
        }
    }

    function getRecordCount(address user) public view returns (uint256) {
        return records[user].length;
    }
}
