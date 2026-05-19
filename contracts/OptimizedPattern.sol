// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OptimizedPattern {
    mapping(address => mapping(uint256 => int256)) public active;
    mapping(address => uint256[]) public timestamps;
    mapping(address => mapping(uint256 => int256)) public backup;
    mapping(address => mapping(uint256 => bytes32)) public archivedHashes;

    uint256 public constant RETENTION_WINDOW = 30 * 24 * 3600;
    uint256 public constant MIGRATION_THRESHOLD = 1000;

    event QualityReported(address indexed user, uint256 timestamp, int256 quality);
    event MigrationCompleted(address indexed user, uint256 timestamp);
    event ArchivalTriggered(address indexed user, uint256 timestamp, bytes32 hash);
    event PurgeCompleted(address indexed user, uint256 timestamp);

    function reportQuality(address user, int256 qualityLevel) public {
        require(qualityLevel >= 0 && qualityLevel <= 100, "Invalid quality level");
        uint256 timestamp = block.timestamp;
        active[user][timestamp] = qualityLevel;
        timestamps[user].push(timestamp);
        emit QualityReported(user, timestamp, qualityLevel);
    }

    function getRecentQualityRecords(address user) public view returns (uint256[] memory, int256[] memory) {
        uint256[] storage tsList = timestamps[user];
        int256[] memory levels = new int256[](tsList.length);
        for (uint256 i = 0; i < tsList.length; i++) {
            levels[i] = active[user][tsList[i]];
        }
        return (tsList, levels);
    }

    function migrateToBackup(address user) public {
        uint256[] storage tsList = timestamps[user];
        require(tsList.length >= MIGRATION_THRESHOLD, "Threshold not reached");
        for (uint256 i = 0; i < tsList.length; i++) {
            uint256 ts = tsList[i];
            if (block.timestamp - ts < RETENTION_WINDOW) {
                backup[user][ts] = active[user][ts];
                delete active[user][ts];
                emit MigrationCompleted(user, ts);
            }
        }
    }

    function triggerArchival(address user, uint256 timestamp) public {
        require(backup[user][timestamp] != 0, "Data not in backup");
        bytes32 hash = keccak256(abi.encodePacked(backup[user][timestamp], timestamp));
        archivedHashes[user][timestamp] = hash;
        emit ArchivalTriggered(user, timestamp, hash);
    }

    function purge(address user, uint256 timestamp) public {
        require(archivedHashes[user][timestamp] != bytes32(0), "Not archived");
        delete backup[user][timestamp];
        delete archivedHashes[user][timestamp];
        emit PurgeCompleted(user, timestamp);
    }

    function getRecordCount(address user) public view returns (uint256) {
        return timestamps[user].length;
    }
}
