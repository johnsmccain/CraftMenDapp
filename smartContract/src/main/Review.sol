// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

contract Review {
    struct JanitorReview {
        uint256 taskId;
        address client;
        uint8 rating;
        string commentsHash;
    }

    mapping(address => JanitorReview[]) public janitorReview;
}
