// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BaselineRingBuffer {
    struct Event { uint256 timestamp; int256 quality; }
    uint256 public constant BUFFER_SIZE = 1000;
    mapping(address => Event[BUFFER_SIZE]) public buffer;
    mapping(address => uint256) public head;
    mapping(address => uint256) public count;

    event QualityReported(address indexed user, uint256 timestamp);

    function reportQuality(address user, int256 qualityLevel) public {
        require(qualityLevel >= 0 && qualityLevel <= 100, "Invalid quality level");
        uint256 timestamp = block.timestamp;
        uint256 pos = head[user];
        buffer[user][pos] = Event(timestamp, qualityLevel);
        head[user] = (pos + 1) % BUFFER_SIZE;
        if (count[user] < BUFFER_SIZE) { count[user]++; }
        emit QualityReported(user, timestamp);
    }

    function getRecentQualityRecords(address user) public view returns (Event[] memory) {
        uint256 len = count[user];
        Event[] memory result = new Event[](len);
        uint256 start = (head[user] + BUFFER_SIZE - len) % BUFFER_SIZE;
        for (uint256 i = 0; i < len; i++) {
        }
        return result;
    }

    function getRecordCount(address user) public view returns (uint256) {
        return count[user];
    }
}
