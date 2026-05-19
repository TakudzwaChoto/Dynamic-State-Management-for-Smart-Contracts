// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaselineArray {
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
        for (uint256 i = 0; i < events.length; i++) {
            if (events[i].timestamp < beforeTimestamp) {
                historicalData[user].push(events[i]);
                _removeElement(events, i);
                i--;
            }
        }
    }

    function _removeElement(Event[] storage arr, uint256 index) internal {
        require(index < arr.length, "Index out of bounds");
        for (uint256 i = index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        arr.pop();
    }

    function getRecordCount(address user) public view returns (uint256) {
        return records[user].length;
    }
}
