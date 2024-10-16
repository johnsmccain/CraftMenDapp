// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Booking} from "src/main/Booking.sol";

contract BookingTest is Test {
    Booking public s_booking;
    uint256 public constant SEND_VALUE = 0.005 ether;
    uint256 private constant INITIAL_BALANCE = 10 ether;
    address public immutable CLIENT = makeAddr("Client");
    address public immutable WORKER = makeAddr("Worker");

    uint256 index = 0;
    Booking.TaskStatus taskStatus;

    modifier funded() {
        vm.prank(CLIENT);
        s_booking.initialEscrow{value: SEND_VALUE}(payable(WORKER));
        _;
    }

    function setUp() public {
        // address x = addr("");
        vm.startBroadcast();
        s_booking = new Booking();
        vm.stopBroadcast();
        vm.deal(CLIENT, INITIAL_BALANCE);
    }

    function testSendFundsToInitialEscrow() public funded {
        assert(address(s_booking).balance == SEND_VALUE);
        assert(CLIENT.balance + SEND_VALUE == INITIAL_BALANCE);
    }

    function testInitialEscrow() public funded funded {
        Booking.Task memory task = s_booking.getTask(index);

        assert(task.id == index);
        assert(task.client == CLIENT);
        assert(task.worker == WORKER);
        assert(task.amount == SEND_VALUE);
        assert(task.status == taskStatus);
    }

    function testAcceptTask() public funded {
        Booking.Task memory task = s_booking.getTask(index);

        assert(uint256(task.status) == uint256(Booking.TaskStatus.Booked));
    }

    function testCompleteTask() public funded {
        // Booking.Task memory task = s_booking.getTask(index);
        // vm.expectRevert();
        // vm.prank(client);
        // s_booking.acceptTask(index);
        // console.log(s_booking.getTask(index).status);

        // assert(
        //     uint256(s_booking.getTask(index).status) ==
        //         uint256(Booking.TaskStatus.InProgress)
        // );

        vm.prank(WORKER);
        s_booking.acceptTask(index);
        assert(
            uint256(s_booking.getTask(index).status) ==
                uint256(Booking.TaskStatus.InProgress)
        );
    }

    function testVerifyTask() public funded {
        Booking.Task memory task = s_booking.getTask(index);

        vm.prank(WORKER);
        s_booking.acceptTask(index);

        vm.prank(WORKER);
        s_booking.completeTask(index);

        uint256 preWorkerBalance = address(task.worker).balance;
        uint256 clientBalance = address(task.client).balance;

        s_booking.verifyTask(index);
        uint256 postWorkerBalance = address(task.worker).balance;
        // assert(s_booking.getTask);
        assert(preWorkerBalance == 0);
        assert(postWorkerBalance == SEND_VALUE);
        assert(clientBalance + postWorkerBalance == INITIAL_BALANCE);
    }

    function testCancelTask() public funded {
        Booking.Task memory task = s_booking.getTask(index);

        uint256 preClientBalance = address(task.client).balance;
        uint256 workerBalance = address(task.worker).balance;

        // vm.prank(WORKER);
        s_booking.cancelTask(index);

        uint256 postClientBalance = address(task.client).balance;

        assert(workerBalance == 0);
        assert(postClientBalance == INITIAL_BALANCE);
        assert(preClientBalance + SEND_VALUE == INITIAL_BALANCE);
        assert(
            uint256(s_booking.getTask(index).status) ==
                uint256(Booking.TaskStatus.Cancelled)
        );
    }
}
